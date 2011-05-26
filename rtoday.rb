#!/usr/bin/env ruby

# Lists today's appointments along with required attendees

require 'rubygems'
require 'highline/import'
require 'viewpoint'

def get_password(prompt="Password: ")
  ask(prompt) { |q|
    q.echo = false
  }
end

def main
  include Viewpoint::EWS

  if ARGV.length != 3
    puts "Usage: rtoday.rb ews-endpoint e-mail login"
    exit
  end
      
  endpoint = ARGV[0]
  email = ARGV[1]
  login = ARGV[2]

  password = get_password

  EWS.endpoint = endpoint
  EWS.set_auth(login, password)

  folder = CalendarFolder.get_folder(:calendar, email)
  folder.todays_items.each { |item|
    puts "#{item.subject}: #{item.start} - #{item.end}"
    unless item.required_attendees.nil?
      item.required_attendees.each { |attendee|
        puts "  #{attendee.email_address}"
      }
    end
  }
end

main
