$empnos = {}

def string_difference_percent(a, b)
  longer = [a.size, b.size].max
  same = a.each_char.zip(b.each_char).select { |a,b| a == b }.size
  (longer - same) / a.size.to_f
end

def read_empno
	ls = File.read('data/emp.txt')
	ls.split("\n").each do |l|
		foo, name, empno = l.split('|')
		empno.strip!
		name.strip!
		#first, last = name.split(' ')
		#name = last+' '+first if last!=nil
		$empnos[name.downcase] = empno
	end
end

def comp
	names.each do |n|
		ranks = []
		$empnos.each do |k, v|
			x = string_difference_percent(n, k)
			ranks << {'n'=>n, 'k'=>k, 'x'=>x}
		end
		ranks.sort! do |a, b|
			a['x'] <=> b['x']
		end
		puts "-----------"
		puts ranks[0]
	end
end

read_empno

names = []
ls = File.read('a')
ls.split("\n").each do |l|
	if l =~/cannot find empno  for (.*)/ then
		names << $1
	end
end
puts names.uniq!

