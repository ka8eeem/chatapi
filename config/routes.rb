Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # found this login in decoupling routes better than nesting the resources with
  # /application/{application_token}/chats/{chat_number}/messages
  # we use various wild cards with ? params

  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :applications, only: [:index, :create, :show, :update], param: :token
      resources :chats, only: [:index, :create, :show, :update], param: :chat_number
      resources :messages, only: [:index, :create, :show, :update], param: :message_number
    end
  end
end


