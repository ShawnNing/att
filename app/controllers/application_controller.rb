class ApplicationController < ActionController::Base
  before_action :load_store 
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def load_store
    @store = Store.find(params[:store_id]) if params[:store_id] != nil
    @store ||= Store.where(:name=>cookies[:current_store])[0]
    @store ||= Store.where(:name=>cookies[:current_store])[0]
    @store ||= Store.where(:name=>Att::Application.config.init_store)[0]
  end    
end
