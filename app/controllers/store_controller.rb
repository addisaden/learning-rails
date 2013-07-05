class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    session[:counter] = (session[:counter] || 1) + 1
  end
end
