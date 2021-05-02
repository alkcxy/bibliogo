class LoansController < ApplicationController
  before_action :authorized
  before_action :set_loan, only: [:show, :edit, :update, :destroy]

  # GET /loans
  # GET /loans.json
  def index
    @loans = Loan.order_by([:date, :desc]).page(params[:page])
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    @loan.book_id = params[:loan][:book_id] if params[:loan] and params[:loan][:book_id]
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(loan_params)
    loans = Loan.where(book_id: @loan.book_id)
    loans_I = loans.where(date:  {'$lte' => @loan.date}).where(expected_return: {'$gte' => (-1*helpers.quarantine_duration).since(@loan.date)})
    loans_II = loans.where(actual_return: nil)
      .where(date:  {'$lte' => @loan.expected_return})

    loans_III = loans.where(actual_return: { '$exists' => true })
      .where(date:  {'$lte' => @loan.expected_return})

    if @loan.actual_return
      logger.debug "Print actual return"
      logger.debug @loan.actual_return
      loans_II = loans_II.where(expected_return: {'$gte' => (-1*helpers.quarantine_duration).since(@loan.actual_return)})
      loans_III = loans_III.where(actual_return: {'$gte' => (-1*helpers.quarantine_duration).since(@loan.actual_return)})
    else
      logger.debug "Print expected return"
      logger.debug @loan.expected_return
      loans_II = loans_II.where(expected_return: {'$gte' => (-1*helpers.quarantine_duration).since(@loan.expected_return)})
      loans_III = loans_III.where(actual_return: {'$gte' => (-1*helpers.quarantine_duration).since(@loan.expected_return)})
    end
    
    loans_count = loans_I.count + loans_II.count + loans_III.count
    logger.debug "Print loans data"
    logger.debug @loan.book_id
    logger.debug @loan.date
 
    logger.debug loans_count
    logger.debug "End Print loans data"

    respond_to do |format|
      if loans_count > 0
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
