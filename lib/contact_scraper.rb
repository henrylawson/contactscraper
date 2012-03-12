require './lib/contact_parser'
require 'selenium-webdriver'

class ContactScraper

  def initialize
    @driver = Selenium::WebDriver.for :firefox
    wait_for_user_to_login
    navigate_to_contacts_section
    wait_for :element => {:class => "jCVCl"}, :until_timeout => 10
    puts ContactParser.new(raw_html).contacts
  end

  def write_raw_html_to_file filename
    File.open(filename, 'w') do |file|
      file.puts raw_html
    end
  end

  def wait_for settings
    wait = Selenium::WebDriver::Wait.new(:timeout => settings[:until_timeout]) # seconds
    wait.until { @driver.find_element(settings[:element]) }
  end

  def navigate_to_contacts_section
    print "Thank you, proceeding to Contacts sections now"
    @driver.navigate.to "https://www.google.com/contacts/u/0/?hl=en&tab=mC#contacts/group/27/Directory"
  end

  def wait_for_user_to_login
    print "Please login to Google Apps using the launched browser and then press <enter>"
    gets
  end

  def raw_html
    @driver.execute_script("return document.body.innerHTML")
  end

end