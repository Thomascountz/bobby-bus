Rails.application.routes.draw do
  root "bobby#index"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
end
