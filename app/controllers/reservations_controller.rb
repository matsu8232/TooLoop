class ReservationsController < ApplicationController
  before_action :set_item
  before_action :set_reservation, only: [:show, :destroy]
  before_action :authorize_reservation_participant!, only: [:show]

  def index
    @from = Date.current + 1
    @to = Date.current >> 1
    @reserved_dates = Reservation.reserved_dates_for_item(@item, from: @from, to: @to)
    @reservations = @item.reservations.where("end_date >= ?", Date.current).order(start_date: :asc)
  end

  def new
    @reservation = @item.reservations.build(user: current_user, start_date: params[:start_date], end_date: params[:end_date])
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.item = @item

    if @reservation.save
      redirect_to item_reservation_path(@item, @reservation), notice: "予約が完了しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    if @reservation.user_id == current_user.id && @reservation.destroy
      redirect_to item_reservations_path(@item), notice: "予約をキャンセルしました。"
    else
      redirect_to item_reservation_path(@item, @reservation), alert: "キャンセルに失敗しました。"
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_reservation
    @reservation = @item.reservations.find(params[:id])
  end

  def authorize_reservation_participant!
    return if @reservation.user_id == current_user.id || @item.user_id == current_user.id

    redirect_to item_path(@item), alert: "この予約を表示する権限がありません。"
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date).merge(item_id: @item.id)
  end
end
