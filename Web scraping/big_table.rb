require_relative 'abstract_table'

# 2nd and 3rd round
CANDIDATES_2004_2 = ["Yushchenko",
                     "Yanukovych",
                     "against.all"]
# 1st round
CANDIDATES_2004_1 = ["Bazylyuk",
                     "Boyko",
                     "Brodskyy",
                     "Vitrenko",
                     "Volha",
                     "Hrabar",
                     "Dushyn",
                     "Zbitnyev",
                     "Kinakh",
                     "Kozak",
                     "Komisarenko",
                     "Korchynskyy",
                     "Kryvobokov",
                     "Moroz",
                     "Nechyporuk",
                     "Omelchenko",
                     "Rzavskyy",
                     "Rogozhynskyy",
                     "Symonenko",
                     "Chernovetsky",
                     "Chornovil",
                     "Yushchenko",
                     "Yakovenko",
                     "Yanukovych",
                     "against.all"]

CANDIDATES_2014 = ["Bogomolets",
                   "Boyko",
                   "Hrynenko",
                   "Hrytsenko",
                   "Dobkin",
                   "Klymenko",
                   "Konovalyuk",
                   "Kuzmin",
                   "Kuybida",
                   "Lyashko",
                   "Malomuzh",
                   "Poroshenko",
                   "Rabinovich",
                   "Saranov",
                   "Symonenko",
                   "Tymoshenko",
                   "Tihipko",
                   "Tiahnybok",
                   "Tsushko",
                   "Shkiryak",
                   "Yarosh"]


TITLES_2004 = ["district.id",
               "date",
               "ballots.printed",
               "total.voters",
               "unused.ballots",
               "received.ballots",
               "actually.voted",
               "invalid.ballots"]

TITLES_2014 = ["district.id",
               "ballots.printed",
               "voters.signed",
               "voters.added",
               "unused.ballots",
               "ballots.received.local",
               "ballots.received.nonlocal",
               "received.ballots",
               "noncounted.ballots",
               "actually.voted",
               "invalid.ballots"]

TITLES_END_2004 = ["constituency", "region"]
TITLES_END_2014 = ["date", "constituency", "region"]

# ------------------------- CLASSES -----------------------------------------

class DistrictVotes

  # one row to array of values 
  attr_accessor :options
  
  def initialize(current) # Nokogiri::XML::Element 
    @options = []
    # substitute globally if there's any \n;
    # excluding first 'chindren' - the initial tag itself
    (1...current.children.length).each do |i|
      @options << current.children[i].text.chomp.gsub(/(\n)/," ")
    end
  end

end


# -------------------- Votes table (small) -------------------------------

class VotesTable < AbstractTable

  def add_district(district)
    @table << district.options
  end

  # add the document not only from itself (html.xpath(parser))
  def add_all(doc)
    (1...doc.length).each do |i| 
      district = DistrictVotes.new(doc[i])
      add_district(district)
    end
  end

end

# ------------------------ Big Table (all data) ------------------------

class BigTable

  PARSER = "//table[@class='t2']/tr"

  attr_accessor :big_table
  attr_reader   :links

  def initialize
    @big_table = []
    @links     = []
    @regions   = []
  end

  def csv_read(dir, mode)
    CSV.foreach(dir,mode) do |row|
      @links << row[2]
      @regions << [row[3].encode('UTF-8'), row[4].encode('UTF-8')]
    end
  end

  def add_data(refs = @links, parse = PARSER)
    refs.each_with_index do |link,j|  # to iterate regions[j]
      tab       = VotesTable.new(link)
      html_doc  = tab.to_doc(parse)

      # add disticts
      tab.add_all(html_doc)
      tab.table.each {|line| @big_table << line + @regions[j]}
    end
  end
  
end


# ----------------------- GLOBAL METHODS ---------------------------

# unused at the time
def titles(document)
  titles = []
  (1...document[0].children.length).each do |i| 
    titles << document[0].children[i].text.chomp
  end
  return titles
end
