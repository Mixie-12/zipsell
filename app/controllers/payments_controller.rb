class PaymentsController < ApplicationController
  before_action :authenticate_admin!, :only => :index

  def index

  end

	def create
    @product = Product.find(params[:payment][:product_id])
    @customer = Customer.find_or_create_by(:email => params[:stripeEmail])
    @payment = @product.payments.new(:stripe_params => params)    
    @payment.customer = @customer

    respond_to do |format|
      if @payment.save!
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :index }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

end