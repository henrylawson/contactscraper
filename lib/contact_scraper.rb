require './lib/contact_parser'
require 'selenium-webdriver'

class ContactScraper

  CONTACT_SPAN_CLASS = "jCVCl"
  NEXT_PAGE_LOADED_TEXT_INDICATOR_ID = ":68"
  NEXT_BUTTON_ID = ":65"
  LONG_TIMEOUT = 10
  SHORT_TIMEOUT = 5

  def initialize
    @driver = Selenium::WebDriver.for :firefox
    wait_for_user_to_login
    navigate_to_contacts_section
    wait_for :element => {:class => CONTACT_SPAN_CLASS}, :until_timeout => LONG_TIMEOUT
    wait_for :element => {:id => NEXT_PAGE_LOADED_TEXT_INDICATOR_ID}, :until_timeout => LONG_TIMEOUT
    click_next_link
    puts ContactParser.new(raw_html).contacts
  end

  def write_raw_html_to_file filename
    File.open(filename, 'w') do |file|
      file.puts raw_html
    end
  end

  def click_next_link
    initial_value = next_page_loaded_indicator_element
    element = @driver.find_element(:id, NEXT_BUTTON_ID)
    element.click
    wait = Selenium::WebDriver::Wait.new(:timeout => SHORT_TIMEOUT)
    wait.until { initial_value != next_page_loaded_indicator_element }
  end

  def next_page_loaded_indicator_element
    @driver.find_element(:id, NEXT_PAGE_LOADED_TEXT_INDICATOR_ID).text
  end

  def wait_for settings
    wait = Selenium::WebDriver::Wait.new(:timeout => settings[:until_timeout])
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