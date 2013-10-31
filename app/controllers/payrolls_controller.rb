class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :edit, :update, :destroy]

  # GET /payrolls
  # GET /payrolls.json
  def index
    @payroll = Payroll.new
    @start_date = Date.today.last_week.last_week.monday.strftime("%Y/%m/%d")
    @end_date = Date.today.last_week.sunday.strftime("%Y/%m/%d")
    @payrolls = Payroll.all
  end
  
  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
    @angularjs = true
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
    @start_date = Date.today.last_week.last_week.monday.strftime("%Y/%m/%d")
    @end_date = Date.today.last_week.sunday.strftime("%Y/%m/%d")
		@angularjs = true
  end

  # GET /payrolls/1/edit
  def edit
		
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)
    respond_to do |format|
      if @payroll.save
        format.html { redirect_to @payroll, notice: 'Payroll was successfully created.' }
        format.json { render action: 'show', status: :created, location: @payroll }
      else
        format.html { render action: 'new' }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1
  # PATCH/PUT /payrolls/1.json
  def update
    if params[:slips] then
      params[:slips_attributes]  = params[:slips]
      params.delete(:slips)
    end

    if params[:destroy_children] == 'true' then
      ids = []
      if params[:slips_attributes] != nil then
        params[:slips_attributes].each do |slip|
          ids << slip[:id]
        end
      end
      @payroll.slips.not_in(:id=>ids).destroy_all
    end
    
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to @payroll, notice: 'Payroll was successfully updated.' }
        format.json { render action: 'show', status: :accepted, location: @payroll }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
  def destroy
    @payroll.destroy
    respond_to do |format|
      format.html { redirect_to payrolls_url }
      format.json { head :no_content }
    end
  end

  def get_employee_hours
		@payroll = Payroll.find(params[:id])
		@employees = @store.employees

		@employees.each do |employee|
			employee.work_hours = employee.get_work_hours(@payroll.start_date, @payroll.end_date)
		end

    respond_to do |format|
      format.html
      format.json do 
#				render json: @employees, :include=>:work_hours
				render json: @employees 
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      return params.permit(:start_date, :end_date, :id, :format, :slips_attributes=>[:id, :notes, :work_hours, :punches=>[:time], :employee=>[:id]])
    end
end
