class Employee
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::Paperclip
  
  belongs_to :store
  has_many :punches
  has_many :slips  
  has_many :payroll_records  
  
  field :num, type: String    
  field :barcode, type: String      
  field :name, type: String
  field :name_cn, type: String
  field :gender, type: Boolean
  field :dob, type: Date
  field :soe, type: Date
  field :eoe, type: Date
  
  field :sin, type: String    
  field :dln, type: String    
  field :ohc, type: String      
  
  field :address, type: String    
  field :city, type: String    
  field :provence, type: String      
  field :postal, type: String      
  
  field :home_phone, type: String    
  field :cell_phone, type: String      
  
  field :department, type: String        
  field :position, type: String, default: 'Employee'
  
  field :rate, type: Float

  field :active, type: Boolean, default: 1
  
  field :status, type: String, default: 'out'
  
  field :manager_id, type: Integer, default: 0
  
  field :notes, type: String  
  field :oid, type: Integer
  
  has_mongoid_attached_file :photo
  
  def get_work_hours(start_date, end_date)
    wh = 0
		last_checkin = nil
    
		self.punches.and({:time.gt => start_date}, {:time.lt => end_date}).order_by(:time.asc).each do |punch|
			if punch.action == 'checkin' then
				last_checkin = punch.time
			elsif punch.action == 'checkout' then
				wh = wh + (punch.time - last_checkin) * 1.day.seconds / 1.hour.seconds.to_f
			end
		end
		return (wh*100).to_i/100.0
  end

	def payroll_report(start_dt, end_dt)
		payroll_records = self.payroll_records.where(:date => { "$lte" => end_dt, "$gte" => start_dt }).order_by(:date.asc)
		
		grand_total = 0
		payroll_records.each do |pr|
			grand_total = grand_total + pr.total
		end
		
		template_file = "template1.odt"
		
		report = ODFReport::Report.new(template_file) do |r|
			r.add_field :report_time, Time.now.strftime("%d/%m/%Y  %l:%M %p")
			r.add_field :employee_name, self.name
			r.add_field :employee_no, self.num
			r.add_field :department, self.department
			r.add_field :start_dt, start_dt.strftime("%d/%m/%Y")
			r.add_field :end_dt, end_dt.strftime("%d/%m/%Y")
			
			r.add_table("PAYROLL", payroll_records, :header=>true) do |t|
				t.add_column(:date) {|pr| pr.date.strftime("%d/%m/%Y %a")}
				t.add_column(:in1) {|pr| pr.in1 != nil ? pr.in1.strftime("%l:%M %p") : ''}
				t.add_column(:out1) {|pr| pr.out1 != nil ? pr.out1.strftime("%l:%M %p") : ''}

				t.add_column(:meal, :meal)
				t.add_column(:overtime, :overtime)
				t.add_column(:sick, :sick)
				t.add_column(:holiday, :holiday)
				t.add_column(:other, :other)
							
				t.add_column(:total, :total)
			end
			
			r.add_field :grand_total, grand_total.round(2)
		end

		odt_file = report.generate
		puts odt_file
		pdf_file = "/tmp/template1.pdf"
		if File.exist?(pdf_file) then
			`rm #{pdf_file}`
		end
		
		puts "libreoffice --headless --invisible --convert-to pdf #{odt_file} --outdir /tmp"
		`libreoffice --headless --invisible --convert-to pdf #{odt_file} --outdir /tmp`

		return pdf_file
	end

end
