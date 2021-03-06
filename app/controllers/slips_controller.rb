class SlipsController < ApplicationController
  before_action :load_payroll  
  before_action :set_slip, only: [:show, :edit, :update, :destroy]

  # GET /slips
  # GET /slips.json
  def index
    @slips = @payroll.slips
  end

  # GET /slips/1
  # GET /slips/1.json
  def show
  end

  # GET /slips/new
  def new
    @slip = Slip.new
  end

  # GET /slips/1/edit
  def edit
  end

  # POST /slips
  # POST /slips.json
  def create
    @payroll = Payroll.find(params[:payroll_id])
    @slip = Slip.new(slip_params)
    respond_to do |format|
      if @slip.save
        format.html { redirect_to [@payroll, @slip], notice: 'Slip was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@payroll, @slip] }
      else
        format.html { render action: 'new' }
        format.json { render json: @slip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slips/1
  # PATCH/PUT /slips/1.json
  def update
    respond_to do |format|
      if @slip.update(slip_params)
        format.html { redirect_to [@payroll, @slip], notice: 'Slip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @slip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slips/1
  # DELETE /slips/1.json
  def destroy
    @slip.destroy
    respond_to do |format|
      format.html { redirect_to payroll_slips_url(@payroll) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slip
      @slip = Slip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slip_params
      params.require(:slip).permit(:start_date, :payroll_id, :employee_id)
    end
    
    def load_payroll
      @payroll = Payroll.find(params[:payroll_id])
    end    
    
end
