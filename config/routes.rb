Rails.application.routes.draw do
  resources :users, :only => [] do
      collection do
        post  'login'
        post  'signup'
        delete 'signout'
      end
    end
end
