class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create
    account = Account.find_or_create_by(id: booking_params[:account_id])
    result = CreateBookingService.call(account: account, **booking_params_for_service)

    respond_to do |format|
      if result.success?
        @booking = result.booking
        format.html { redirect_to @booking, notice: "Booking was successfully created." }
        format.json { render :show, status: :created, location: @booking }
      else
        @booking = result.booking
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    @booking = Booking.new(booking_params)
    @booking.errors.add(:account, "must exist")
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @booking.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    result = UpdateBookingService.call(booking: @booking, **booking_params_for_service)

    respond_to do |format|
      if result.success?
        @booking = result.booking
        format.html { redirect_to @booking, notice: "Booking was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @booking }
      else
        @booking = result.booking
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  rescue RuntimeError => e
    if e.message.match?(/pet type|animal not found/i)
      @booking.assign_attributes(booking_params)
      @booking.errors.add(:pet_type, e.message)
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    else
      raise
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    result = DeleteBookingService.call(booking: @booking)

    respond_to do |format|
      if result.success?
        format.html { redirect_to bookings_path, notice: "Booking was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      else
        format.html { redirect_to bookings_path, alert: result.errors&.full_messages&.to_sentence.presence || "Could not destroy booking.", status: :see_other }
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:account_id, :first_name, :last_name, :pet_name, :pet_type, :expected_fee, :time_span, :date_of_service)
    end

    def booking_params_for_service
      booking_params.except(:account_id).to_h.symbolize_keys
    end
end
