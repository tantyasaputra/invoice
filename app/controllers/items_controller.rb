# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  include Swagger::Blocks
  
  def index
    @items = Item.all
    render json: @items
  end

  # GET /items/:id
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/:id
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'item not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :description, :unit_price)
  end
end
