# This file is part of the OpenWISP User Management System
#
# Copyright (C) 2012 OpenWISP.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

Owums::Application.routes.draw do
  #### Named Routes --->
  match '/account/login' => 'account_sessions#new', :as => :account_login
  match '/account/logout' => 'account_sessions#destroy', :as => :account_logout, :via => 'delete'
  match '/account/signup' => 'accounts#new', :as => :account_registration
  match '/account/instructions' => 'accounts#instructions', :as => :account_instructions
  match '/account/reset' => 'password_resets#new', :as => :password_reset
  match '/account/verification' => 'accounts#verification', :as => :verification
  match '/account/verify_credit_card' => 'accounts#verify_credit_card', :as => :verify_credit_card, :via => 'post'
  match '/account/secure_verify_credit_card' => 'accounts#secure_verify_credit_card', :as => :secure_verify_credit_card, :via => 'post'
  match '/account/buy_product' => 'accounts#buy_product', :as => :buy_product

  match '/users/browse' => 'users#index', :as => :users_browse
  match '/users/search' => 'users#search', :as => :users_search
  match '/users/find' => 'users#find', :via => 'post'
  
  match '/createdownload/:id' => 'users#createdownload', :as => :createdownload
  match '/createPDF/:id' => 'users#createPDF', :as => :createPDF

  match '/mobile_phone_password_resets/:id/recovery_confirmation' => 'mobile_phone_password_resets#recovery_confirmation', :as => :recovery_confirmation

  captcha_route
  match '/spoken_captcha.mp3' => 'spoken_captcha#show', :as => :spoken_captcha

  match '/operator/login' => 'operator_sessions#new', :as => :operator_login
  match '/operator/logout' => 'operator_sessions#destroy', :as => :operator_logout, :via => :delete

  match '/toggle_mobile' => 'application#toggle_mobile', :as => :toggle_mobile
  
  match '/cpe_template_delete/:id' => 'cpe_templates#destroy', :as => :cpe_template_delete
  match '/product_delete/:id' => 'products#destroy', :as => :product_delete
  ####################

  #### Resources --->
  resource :account do
    resources :stats, :only => :show
  end
  resource :account_session
  resource :operator_session
  resources :configurations
  resources :products
  resources :cpe_templates
  resources :users do
    resources :stats, :only => :show
    resources :radius_checks
    resources :radius_replies
    resources :radius_accountings, :only => :index
  end
  resources :radius_groups do
    resources :radius_checks
    resources :radius_replies
  end
  resources :online_users, :only => :index
  resources :operators
  resources :password_resets
  resources :email_password_resets

  resources :mobile_phone_password_resets do
    get :verification, :on => :member
  end

  resources :stats, :only => [:index, :show] do
    post :export, :on => :collection
  end
  ###################

  #### Root Route --->
  root :to => "accounts#instructions"
end
