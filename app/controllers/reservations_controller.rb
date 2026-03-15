class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item

  def index
    @reservations = @item.reservations.where("end_date >= ?", Date.current).order(start_date: :asc)
  end

  def new
    @reservation = Reservation.new(item: @item, user: current_user)
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    message = Reservation.check_reservation_period(@item, @start_date, @end_date)
    if message
      redirect_to item_reservations_path(@item), alert: message
      return
    end

    @reservation.start_date = @start_date
    @reservation.end_date = @end_date
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.item = @item

    message = Reservation.check_reservation_period(@item, @reservation.start_date, @reservation.end_date)
    if message
      redirect_to new_item_reservation_path(@item, start_date: params[:reservation][:start_date], end_date: params[:reservation][:end_date]), alert: message
      return
    end

    if @reservation.save
      redirect_to item_reservation_path(@item, @reservation), notice: "予約が完了しました。"
    else
      @start_date = @reservation.start_date
      @end_date = @reservation.end_date
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = @item.reservations.find(params[:id])
  end

  def destroy
    @reservation = @item.reservations.find(params[:id])
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

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date).merge(item_id: @item.id)
  end
end
