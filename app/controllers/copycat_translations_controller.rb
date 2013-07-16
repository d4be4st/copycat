class CopycatTranslationsController < ActionController::Base

  http_basic_authenticate_with :name => Copycat.username, :password => Copycat.password

  layout 'copycat'

  def index
    params[:locale] = I18n.default_locale unless params.has_key?(:locale)

    @locale_names = CopycatTranslation.defined_locales
    @copycat_translations = []

    return unless params.has_key?(:search)

    @copycat_translations = CopycatTranslation.search(params[:locale],
                                                      params[:search])
  end

  def edit
    @copycat_translation = CopycatTranslation.find(params[:id])
  end

  def update
    @copycat_translation = CopycatTranslation.find(params[:id])
    @copycat_translation.value = copycat_translation_params[:value]
    @copycat_translation.save!
    redirect_to copycat_translations_path, :notice => "#{@copycat_translation.key} updated!"
  end

  def import_export
  end

  def download
    filename = "copycat_translations_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.yml"
    send_data CopycatTranslation.export_yaml, :filename => filename
  end

  def upload
    begin
      CopycatTranslation.import_yaml(params["file"].tempfile)
    rescue Exception => e
      logger.info "\n#{e.class}\n#{e.message}"
      flash[:notice] = "There was an error processing your upload!"
      render :action => 'import_export', :status => 400
    else
      redirect_to copycat_translations_path, :notice => "YAML file uploaded successfully!"
    end
  end

  def destroy
    @copycat_translation = CopycatTranslation.find(params[:id])
    notice = "#{@copycat_translation.key} deleted!"
    @copycat_translation.destroy
    redirect_to copycat_translations_path, :notice => notice
  end

  def help
  end

  def sync
    if Copycat.staging_server_endpoint.nil?
      redirect_to :back, alert: 'You didn\'t set your source server'
    else
      yaml = read_remote_yaml(Copycat.staging_server_endpoint)

      if yaml
        CopycatTranslation.import_yaml(yaml)
        redirect_to :back, notice: "Translations synced from source server"
      else
        redirect_to :back
      end

    end
  end

  protected

  def read_remote_yaml(url)
    output = nil
    begin
      open(url, http_basic_authentication: [Copycat.username, Copycat.password]) do |remote|
        output = remote.read()
      end
    rescue Exception => e
      logger.fatal e
      flash[:alert] = "Syncing failed: #{e}"
    end
    output
  end

  def copycat_translation_params
    params[:copycat_translation].permit(:value)
  end
end
