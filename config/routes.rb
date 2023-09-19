Rails.application.routes.draw do
  resources :settings
  resources :daily_transaction_details
  resources :currencies
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'dashboard' => 'home#dashboard'
  get 'accounts_tree' => 'accounts#accounts_tree'
  post 'search_accounts' => 'daily_transactions#search_accounts'
  post 'transaction_details' => 'daily_transactions#transaction_details'
  get 'draw_trial_balance' => 'trial_balance#get_datatable'
  post 'export_trial_balance' => 'trial_balance#export_trial_balance'
  get 'export_pdf' => 'trial_balance#export_pdf'

  


  get 'trial_balance' => 'trial_balance#index'

  get 'account_statements' => 'account_statements#index'
  get 'draw_account_statement' => 'account_statements#draw_account_statement'
  get 'draw_currencies' => 'currencies#draw_currencies'


  resources :cost_centers do
    collection do 
      get :trial_balance
      get :get_datatable
      get :account_statements
      get :get_account_statement
    end
  end


  resources :accounts do
    collection { 
      post :import 
      get :export_form
    }
  end

  resources :daily_transactions do
    collection { post :import }
  end
  
end
