class OrdersController < ApplicationController

  # creating a new order doesn't need authorization so every user can do it
  skip_before_action :authorize, only: [:new, :create]

  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: %i[ show edit update destroy ]

  # send email when RecordNotFound occurs
  rescue_from ActiveRecord::RecordNotFound, with: :email_admin

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        ChargeOrderJob.perform_later(@order, pay_type_params.to_h)
        format.html { redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      # get the current order and store its ship_date
      @order = Order.find(params[:id])
      old_ship_date = @order.ship_date

      if @order.update(order_params)
        #ship_date update send email method
        send_shipped_email :old_ship_date

        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pay_type_params
    # notice that in every component in PayTypeSelector we've named the fields in such
    # a way so that we can access them here easily
    # these params can be used to submit the payment details to the customer's
    # back-end payment processing system
    if order_params[:pay_type] == "Credit Card"
      params.require(:order).permit(:credit_card_number, :expiration_date)
    elsif order_params[:pay_type] == "Check"
      params.require(:order).permit(:routing_number, :account_number)
    elsif order_params[:pay_type] == "Purchase Order"
      params.require(:order).permit(:po_number)
    else
      {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type, :ship_date)
  end

  # If there is nothing in the cart we redirect the user to the store page in order to add sth to cart
  def ensure_cart_isnt_empty
    if @cart.line_items.empty?
      redirect_to store_index_url, notice: 'Your cart is empty'
    end
  end

  # if the ship_date of the order has changed, an email is sent to the customer
  def send_shipped_email(old_ship_date)
    if @order.ship_date != old_ship_date
      ShippedJob.perform_later(@order)
    end
  end

  def email_admin
    FailureMailer.failure_occured.deliver_now
    redirect_to orders_url
  end
end
