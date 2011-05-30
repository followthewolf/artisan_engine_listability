Rails.application.routes.draw do
  scope :module => :manage do
    post '/sort/:type' => 'sort#sort', :as => 'sort'
  end
end