require_relative 'abstract_table'

# 2014 votes:
HREF_PREFIX = "http://www.cvk.gov.ua/pls/vp2014/"
HREF_SUFFIX = "WP335ef31.html?PT001F01=702"

# 2004 votes:
# HREF_PREFIX = "http://www.cvk.gov.ua/pls/vp2004/" (inactive at the moment)
# HREF_SUFFIX = "WP335?PT001F01=500" # 501 and 502 for the next rounds

# ------------------------- CLASSES -----------------------------------------

class Constituency

  # one row to array of values 
  attr_accessor :id, :number, :link, :t_v_o
  
  def initialize(current)
  # current - Nokogiri::XML::Element (inside some tag)
    @id       = current.children[1].text.chomp
    # href is a link to votes table (="" if empty)
    href = current.children[2]
    @number   = href.text.chomp.to_i
    # if no link - .css('a').length should be 0
    @link     = (href.css('a').length == 1) ? 
                HREF_PREFIX + "#{href.css('a').first.attributes["href"].value}" : ""
    @t_v_o    = current.children[4].text.chomp.to_s.gsub(/(\\")/,"")
  end

  def to_array 
    [@id, @number, @link, @t_v_o]
  end

end


class Region
  
  attr_accessor :name, :content
  
  # document - Nokogiri::XML::NodeSet,
  # initial i = 1 (name of region) as i=0 corresponds to column names
  def initialize(document, i = 1)
    @name     = document[i].css('td').text.chomp.gsub(/ -.*/,"")
    @content  = []
  end

  # expands @content by adding @name
  # [ [@id1, @number1, @link1, @t_v_o1, @name], ...]
  def to_array
    @content.map {|c| c + [@name]}
  end

  # adds constituency properties to array @content
  # [[@id1, @number1, @link1, @t_v_o1], [@id2, @number2, @link2, @t_v_o2], ...]
  def add_constituency(constituency)
    @content << constituency.to_array
  end

  def drop_constituency(n = nil)
    if n
      @content = @content.drop n 
    else
      @content.pop
    end
  end

end


class ConstituencyTable < AbstractTable

  def add_region(region)
    @table << region.to_array
  end

end


# ----------------------- GLOBAL METHODS ---------------------------

# detects next tag class
def next_type(doc, margin = "td10") # td10 means the name of new region
  next_type = doc.next_sibling.children[1].attributes["class"].value
rescue NoMethodError
  next_type = margin # if end of <table> assign manually and end cycle
end


def create_region(document, i = 1, margin = "td10")
  region  = Region.new(document,i) # i = 1 - name of region
  current = document[i]

  # while inside current region
  while next_type(current, margin) != margin do
    i += 1 # increase to get 'inside' region
    current = document[i]
    # add constituency only if non-nil (occupied by russia)
    # maybe it should be set in separate method #empty? or so
    if current.children[2].css('a').length == 1
      region.add_constituency Constituency.new(current)
    end
  end

  return region, i  # array and current iterator
end


# could fill the table from different document, not only from itself
def fill_table(table, document)
  iterator = 1

  while iterator < document.length do
    region, iterator = create_region(document, iterator)
    table.add_region region

    # p region.to_array.length        # monitor length of each region
    iterator += 1
  end
end