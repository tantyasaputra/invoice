# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_item, only: %i[show update destroy]
  include Swagger::Blocks

  swagger_path '/items' do
    operation :get do
      key :summary, 'Fetches all Items'
      key :description, 'Returns all items from the system that the user has access to'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Items'
      ]
      security do
        key :api_key, []
      end
      response 200 do
        key :description, 'item response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Item
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', { error: 'asu' }
        end
      end
    end
    operation :post do
      key :description, "Creates a new items. Item's name must be uniq"
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Items'
      ]
      security do
        key :api_key, []
      end
      parameter do
        key :name, :body
        key :in, :body
        key :description, 'Item object that needs to be sent in the params'
        key :required, true
        schema do
          key :'$ref', :ItemInput
        end
      end
      response 200 do
        key :description, 'pet response'
        schema do
          key :'$ref', :Item
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_schema :Item do
    key :required, %i[id name unit_price]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :unit_price do
      key :type, :number
      key :format, :double
    end
  end
  swagger_schema :ItemInput do
    allOf do
      schema do
        key :'$ref', :Item
      end
      schema do
        key :required, %i[name unit_price]
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :name do
          key :type, :string
          key :format, :int64
        end
        property :unit_price do
          key :type, :number
          key :format, :double
        end
      end
    end
  end

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
