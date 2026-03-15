class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @items = @user.items.page(params[:page]).per(8).reverse_order

    @future_reservations = @user.reservations.where('end_date >= ?', Date.current).includes(:item).order(start_date: :asc)
    @past_reservations = @user.reservations.where('end_date < ?', Date.current).includes(:item).order(start_date: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :info, :avatar)
  end
end
