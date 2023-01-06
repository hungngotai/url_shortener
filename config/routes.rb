# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/encoded', to: 'url#encoded'
  post '/decoded', to: 'url#decoded'
end
