ImageConverter::Application.routes.draw do

  resources :converter do
    collection do
      post :upload  , :action => :upload
      get  :download, :action => :download
      get  :convert , :action => :convert
    end
    member do
      get  :uploaded, :action => :uploaded
    end
  end
  root :to => 'converter#index'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
