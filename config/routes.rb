Rails.application.routes.draw do
  devise_for :customers
  devise_for :admins
  root "staticpages#top"
end
