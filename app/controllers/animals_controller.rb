class AnimalsController < ApplicationController
  before_action :set_account, only: %i[ index new create ]
  before_action :set_animal, only: %i[ show edit update destroy ]

  # GET /animals or GET /accounts/:account_id/animals
  def index
    @animals = @account ? @account.animals : Animal.all
  end

  # GET /animals/1 or /animals/1.json
  def show
  end

  # GET /animals/new or GET /accounts/:account_id/animals/new
  def new
    @animal = @account ? @account.animals.build : Animal.new
  end

  # GET /animals/1/edit
  def edit
  end

  # POST /animals or POST /accounts/:account_id/animals
  def create
    @animal = @account ? @account.animals.build(animal_params) : Animal.new(animal_params)

    respond_to do |format|
      if @animal.save
        format.html { redirect_to @account ? account_animals_path(@account) : @animal, notice: "Animal was successfully created." }
        format.json { render :show, status: :created, location: @animal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to @animal, notice: "Animal was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @animal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    @animal.destroy!

    respond_to do |format|
      format.html { redirect_to account_animals_path(@animal.account), notice: "Animal was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_account
      @account = Account.find(params[:account_id]) if params[:account_id].present?
    end

    def set_animal
      @animal = Animal.find(params[:id])
    end

    def animal_params
      params.require(:animal).permit(:account_id, :name, :additional_hour_fee)
    end
end
