class SequencesController < ApplicationController
  before_action :set_sequence, only: %i[ show edit update destroy ]
  before_action :authorized

  # GET /sequences or /sequences.json
  def index
    @sequences = Sequence.all
  end

  # GET /sequences/1 or /sequences/1.json
  def show
  end

  # GET /sequences/new
  def new
    @sequence = Sequence.new
  end

  # POST /sequences or /sequences.json
  def create
    @sequence = Sequence.new(sequence_params)

    respond_to do |format|
      if @sequence.save
        format.html { redirect_to @sequence, notice: "Sequence was successfully created." }
        format.json { render :show, status: :created, location: @sequence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sequence
      @sequence = Sequence.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sequence_params
      params.require(:sequence).permit(:key, :value)
    end
end
