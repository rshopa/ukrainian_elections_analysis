require 'HTTParty'
require 'Nokogiri'
require 'csv'

require_relative 'constituencies'
require_relative 'big_table'

#----------------- CREATE FILE OF LINKS TO CONSTITUENCIES ----------------

print "Loading links to constituencies..."

tab = ConstituencyTable.new(HREF_PREFIX + HREF_SUFFIX)
html2 = tab.to_doc "//table[@class='t2']/tr"

# fill in table with unoccupied (if any) constituencies
fill_table(tab, html2)
# (!!!) update last region as it has no name
tab.table.last.each {|x| x[-1] = "Закордонний виборчий округ"}

# output to file
CSV.open("constituencies_2014.csv", "wb:windows-1251") do |csv|
  tab.table.each do |r|
    r.each do |d|
      csv << [d[0],d[1],d[2],d[3],d[4]]
    end
  end
end # CSV

puts "Done!"

#---------------- GRAB VOTES RESULTS AND SAVE TO FILE --------------------

print "\nGrabbing results"

big_table = BigTable.new

thr = Thread.new do

	big_table.csv_read("constituencies_2014.csv", "r:windows-1251")
	big_table.add_data(big_table.links)

	# titles_2004 = TITLES_2004 + CANDIDATES_2004_1 + TITLES_END_2004
	titles_2014 =  TITLES_2014 + CANDIDATES_2014 + TITLES_END_2014

	# add titles
	big_table.big_table.unshift(titles_2014)

	# save to file
	CSV.open("all_test_2014.csv", "wb:windows-1251") do |csv|
	  big_table.big_table.each do |d|
	    csv << d
	  end
	end

end # Thread

while thr.alive?
 	print(".")
  sleep(1)
end
thr.join
puts "Done!"