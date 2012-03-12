require './lib/contact_parser'

describe ContactParser do

  before(:each) do
    @parser = ContactParser.new '<span email="email@hanks.com">Tom Hanks</span><span email="yo@gerrard.com">Yo Gerrard</span>'
  end

  it "should retrive all span contact elements" do
    span_contact_elements = @parser.find_all_span_contact_elements
    span_contact_elements.count.should eq(2)
  end

  it "should return contact as name email map" do
    contacts = @parser.contacts
    contacts[0].should eq({:name => 'Tom Hanks', :email => 'email@hanks.com'})
    contacts[1].should eq({:name => 'Yo Gerrard', :email => 'yo@gerrard.com'})
  end

end