payroll = Payroll.first
slip = payroll.slips.first
p slip.punches.as_json
payroll.save
