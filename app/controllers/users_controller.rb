class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user_self!, only: [:edit, :update]

  def show
    @items = @user.items.page(params[:page]).per(8).reverse_order

    @future_reservations = @user.reservations.where('end_date >= ?', Date.current).includes(:item).order(start_date: :asc)
    @past_reservations = @user.reservations.where('end_date < ?', Date.current).includes(:item).order(start_date: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user_self!
    return if @user == current_user

    redirect_to root_path, alert: "このページを表示する権限がありません。"
  end

  def user_params
    params.require(:user).permit(:name, :email, :info, :avatar)
  end
end
