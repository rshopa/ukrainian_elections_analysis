# Web scraping (Ruby)

This part of the project was focused on obtaining election results from the Ukrainian [Central Election Commission](http://www.cvk.gov.ua/ "official site")
(CEC) site. As there are no downloading formats available, web scraping tools were used.

As mentioned initially, the data included 3 rounds of the President elections in 2004 (with enormous vote manipulation that 
caused [Orange Revolution](https://en.wikipedia.org/wiki/Orange_Revolution)) and in 2014 (after 
[Euromaidan](https://en.wikipedia.org/wiki/Euromaidan) and 
[Russian aggression with annexation of Crimea](https://en.wikipedia.org/wiki/Russian_military_intervention_in_Ukraine_(2014%E2%80%93present))).

For unknown reasons some of the links are obsolete in the CEC site at the moment, most of the data were scraped during June 2016. 
Datasets from other countries ([Canada](http://www.elections.ca/content.aspx?section=ele&document=index&dir=pas/42ge&lang=e) 
and [Poland](http://parlament2015.pkw.gov.pl/347_Wyniki)) used for comparison were downloaded in friendly format (.csv) directly.

The gems used in Ruby included [HTTParty](https://github.com/jnunemaker/httparty),  [Nokogiri](https://github.com/sparklemotion/nokogiri) 
and [CSV](http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html). The programs were not designed for commercial use, 
so no test scripts and Gem files were used at the moment.
