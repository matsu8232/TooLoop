class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @items = @user.items.page(params[:page]).per(8).reverse_order
  end
end
