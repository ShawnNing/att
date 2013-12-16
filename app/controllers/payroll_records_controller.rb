class PayrollRecordsController < ApplicationController
	before_action :load_employee
  before_action :set_payroll_record, only: [:show, :edit, :update, :destroy]

  # GET /payroll_records
  # GET /payroll_records.json
  def index
		if params[:date] != nil then
			@dt = Date.parse(params[:date])
			start_dt = @dt.beginning_of_week
			end_dt = @dt.end_of_week
			@payroll_records = @employee.payroll_records.where(:date => { "$lte" => end_dt, "$gte" => start_dt }).order_by(:date.asc)
		else
			@payroll_records = @employee.payroll_records.order_by(:date.asc)
		end
  end
	
  def report
		if params[:date] != nil then
			@dt = Date.parse(params[:date])
			pdf_file = @employee.payroll_report(@dt)

			send_file(pdf_file, :type => 'application/pdf', :disposition => 'attachment', :filename => "report-#{@dt}")
		end
  end

  # GET /payroll_records/1
  # GET /payroll_records/1.json
  def show
  end

  # GET /payroll_records/new
  def new
    @payroll_record = PayrollRecord.new
  end

  # GET /payroll_records/1/edit
  def edit
  end

  # POST /payroll_records
  # POST /payroll_records.json
  def create
    @payroll_record = @employee.payroll_records.build(payroll_record_params)

    respond_to do |format|
      if @payroll_record.save
        format.html { redirect_to [@employee, @payroll_record], notice: 'Payroll record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @payroll_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @payroll_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payroll_records/1
  # PATCH/PUT /payroll_records/1.json
  def update
    respond_to do |format|
      if @payroll_record.update(payroll_record_params)
        format.html { redirect_to @payroll_record, notice: 'Payroll record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payroll_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_records/1
  # DELETE /payroll_records/1.json
  def destroy
    @payroll_record.destroy
    respond_to do |format|
      format.html { redirect_to payroll_records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll_record
      @payroll_record = PayrollRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_record_params
			return params.permit(:in1, :out1, :date, :sick, :holiday, :other, :overtime, :meal)
    end
		
    def load_employee
      @employee = Employee.find(params[:employee_id])
    end    

end
