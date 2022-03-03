class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_product

  # GET /products or /products.json
  def index
    @products = Product.all.order(:title)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        puts @product.errors.full_messages #to print better message in testing failure
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }

        @products = Product.all.order(:title)
        ActionCable.server.broadcast( 'products', {html: render_to_string('store/index', layout: false ), product_id: @product.id})
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    respond_to do |format|
      format.html { render :who_bought } # chapter 12 playtime 1. html who_bought request
      format.json { render :who_bought, status: :ok } # json who_bought request
      format.xml { render @product.as_json } # xml who_bought request
      format.atom if stale?(@latest_order)
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :description, :image_url, :price, :locale)
  end

  def invalid_product
    logger.error "Attempt to access invalid product #{params[:id]}"
    redirect_to store_index_url, notice: 'Invalid product'
  end

end
