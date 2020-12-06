Rails.application.routes.draw do
  # resources :sms_apis
  root to: proc { [405, {}, ['']] }
  post '/inbound/sms', to: 'sms_apis#inbound_sms', as: 'inbound_sms'
  post '/outbound/sms', to: 'sms_apis#outbound', as: 'outbound_sms'
end