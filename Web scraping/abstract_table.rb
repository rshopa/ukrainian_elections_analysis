class AbstractTable

  attr_accessor :table

  def initialize(ref) # reference to web-page
    @page   = HTTParty.get(ref)
    @table  = []
  end

  # creates Nokogiri::XML::NodeSet
  def to_doc(parser)
    html.xpath(parser)
  end

  private

    def html
      Nokogiri::HTML(@page)
    end

end