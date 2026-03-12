class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    if @item.save
      redirect_to item_path(@item.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @items = Item.page(params[:page]).reverse_order
    @items = @items.where('name LIKE ?', "%#{params[:keyword]}%") if params[:keyword].present?
    @categories = Category.all
    if params[:category_ids].present?
      @items = @items.where(category_id: params[:category_ids])
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path
  end

  private
  def item_params
    params.require(:item).permit(:user_id, :name, :description, :category_id, :status, :image)
  end
end
