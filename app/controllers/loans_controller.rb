class LoansController < ApplicationController
  before_action :authorized
  before_action :set_loan, only: [:show, :edit, :update, :destroy]

  # GET /loans
  # GET /loans.json
  def index
    @loans = Loan.where(actual_return: nil).order_by([:date, :desc]).page(params[:page])
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    @loan.book_id = params[:loan][:book_id] if params[:loan] and params[:loan][:book_id]
    today = Date.today
    @loan.date = today
    @loan.expected_return = helpers.day_of_expected_return_in_setting.since today
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(loan_params)
    if !@loan.valid?
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
      return
    end
    loans = @loan.book.loans.active(@loan.date, helpers.quarantine_duration.since(@loan.expected_return))

    respond_to do |format|
      if loans.count > 0
        flash.now[:notice] = 'Book already lent for this period.'
        format.html { render :new }
        format.json { render json: { message: 'Book already lent for this period.' }, status: :unprocessable_entity }
      elsif @loan.save
        format.html { redirect_to @loan, notice: 'Loan was successfully created.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1
  # PATCH/PUT /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: 'Loan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.require(:loan).permit(:date, :expected_return, :actual_return, :place, :reader, :book_id)
    end
end
