Rails.application.routes.draw do
  resources :copycat_translations, :only => [:index, :edit, :update] do
    collection do
      get 'readme'
      get 'import_export'
      get 'download'
      post 'upload'
    end
  end
end
