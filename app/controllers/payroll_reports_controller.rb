class PayrollReportsController < ApplicationController
  before_action :set_payroll_report, only: [:show, :edit, :update, :destroy]

  # GET /payroll_reports
  # GET /payroll_reports.json
  def index
    @payroll_reports = PayrollReport.all
  end

  # GET /payroll_reports/1
  # GET /payroll_reports/1.json
  def show
  end

  # GET /payroll_reports/new
  def new
    @payroll_report = PayrollReport.new
  end

  # GET /payroll_reports/1/edit
  def edit
  end

  # POST /payroll_reports
  # POST /payroll_reports.json
  def create
    @payroll_report = PayrollReport.new(payroll_report_params)

    respond_to do |format|
      if @payroll_report.save
        format.html { redirect_to @payroll_report, notice: 'Payroll report was successfully created.' }
        format.json { render action: 'show', status: :created, location: @payroll_report }
      else
        format.html { render action: 'new' }
        format.json { render json: @payroll_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payroll_reports/1
  # PATCH/PUT /payroll_reports/1.json
  def update
    respond_to do |format|
      if @payroll_report.update(payroll_report_params)
        format.html { redirect_to @payroll_report, notice: 'Payroll report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payroll_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_reports/1
  # DELETE /payroll_reports/1.json
  def destroy
    @payroll_report.destroy
    respond_to do |format|
      format.html { redirect_to payroll_reports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll_report
      @payroll_report = PayrollReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_report_params
      params[:payroll_report]
    end
end
