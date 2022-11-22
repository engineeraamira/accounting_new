Rails.application.routes.draw do
  resources :daily_transaction_details
  resources :daily_transactions
  resources :currencies
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'accounts_tree' => 'accounts#accounts_tree'
  post 'search_accounts' => 'daily_transactions#search_accounts'
  post 'transaction_details' => 'daily_transactions#transaction_details'
  get 'draw_trial_balance' => 'trial_balance#get_datatable'


  get 'trial_balance' => 'trial_balance#index'

  get 'account_statements' => 'account_statements#index'
  get 'draw_account_statement' => 'account_statements#draw_account_statement'


  resources :cost_centers do
    collection do 
      get :trial_balance
      get :get_datatable
    end
  end


  resources :accounts do
    collection { post :import }
  end

  
end
