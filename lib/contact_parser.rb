require 'nokogiri'

class ContactParser

  def initialize html
    @html = html
    @doc = Nokogiri::HTML(@html)
  end

  def find_all_span_contact_elements
    @doc.xpath('//span[@email]')
  end

  def contacts
    contacts = []
    find_all_span_contact_elements.each do |span_element|
      contacts.push({:name => span_element.text, :email => span_element[:email]})
    end
    contacts
  end
end