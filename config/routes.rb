# frozen_string_literal: true

# == Route Map
#
#            Prefix Verb   URI Pattern                   Controller#Action
#          rswag_ui        /api-docs                     Rswag::Ui::Engine
#         rswag_api        /api-docs                     Rswag::Api::Engine
# api_v1_auth_login POST   /api/v1/auth/login(.:format)  api/v1/authentication#create {:format=>"json"}
#      api_v1_users GET    /api/v1/users(.:format)       api/v1/users#index {:format=>"json"}
#                   POST   /api/v1/users(.:format)       api/v1/users#create {:format=>"json"}
#       api_v1_user GET    /api/v1/users/:id(.:format)   api/v1/users#show {:format=>"json"}
#                   PATCH  /api/v1/users/:id(.:format)   api/v1/users#update {:format=>"json"}
#                   PUT    /api/v1/users/:id(.:format)   api/v1/users#update {:format=>"json"}
#                   DELETE /api/v1/users/:id(.:format)   api/v1/users#destroy {:format=>"json"}
#    api_v1_entries GET    /api/v1/entries(.:format)     api/v1/entries#index {:format=>"json"}
#                   POST   /api/v1/entries(.:format)     api/v1/entries#create {:format=>"json"}
#      api_v1_entry GET    /api/v1/entries/:id(.:format) api/v1/entries#show {:format=>"json"}
#                   PATCH  /api/v1/entries/:id(.:format) api/v1/entries#update {:format=>"json"}
#                   PUT    /api/v1/entries/:id(.:format) api/v1/entries#update {:format=>"json"}
#                   DELETE /api/v1/entries/:id(.:format) api/v1/entries#destroy {:format=>"json"}
#    api_v1_reports GET    /api/v1/reports(.:format)     api/v1/reports#index {:format=>"json"}
#            api_v1        /api/v1/*path(.:format)       api/v1/api#routing_error {:format=>"json"}
# 
# Routes for Rswag::Ui::Engine:
# 
# 
# Routes for Rswag::Api::Engine:

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/auth/login', to: 'authentication#create'

      resources :users
      resources :entries
      resources :reports, only: %i[index]

      match '*path', to: 'api#routing_error', via: :all
    end
  end
end
