#!/usr/bin/env ruby

# Hue Documnetaion:
# Get a Hue Developer account for docs access
# https://developers.meethue.com/develop/get-started-2/core-concepts/

# Hue Colors:
# Handy list of colors - also can set it via the Hue app and query with this app
# https://www.enigmaticdevices.com/philips-hue-lights-popular-xy-color-values/

# hue-lights-tester.rb
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'net/http'
require 'openssl'
require 'rubygems'
require 'thor'
require 'uri'
require "awesome_print"

# SETUP:
# The IP of your Hue Hub
$hue_hub_ip = "<enter your hue hub ip address>"

# Your device provided developer key
$developer_key = "<enter your hue developer license>"

# Sample lights
$light_ids = [
  21, # Office 5
  22, # Office 4
  25, # Office 2
  26, # Office 3
  27, # Office 1
  17, # Office 1
  28  # Holiday 1
]

# Sample colored used in animations - using Hue XY
$selected_colors_xy = [
  [0.1821,0.0698], #midnightblue
  # [0.6725,0.3230], #orangered
  # [0.4091,0.518], #darkgreen
  # [0.2485,0.0917], #indigo
  [0.6455, 0.3428] #darkorange
]

$hub_uri = URI("https://#{$hue_hub_ip}/api/#{$developer_key}")

# ----------------------------------------------------------------------

class HueControler < Thor

  desc "discover", "Discover the lights and respective ids."
  def discover
      puts "Hue Light Discovery!"

      webinit
      response = @conn.get('lights')
      response.body

      response.body.each do |light|
        puts "#{light[0]} - #{light[1]['name']} - #{light[1]['state']['on']}"
        # puts JSON.pretty_generate(light)
      end
      # puts JSON.pretty_generate(response.body)
  end

  # ----------------------------------------------------------------------

  desc "config", "Find out detail on your hue configuration items"
  def config
      puts "Getting all the configuration items."

      webinit

      response = @conn.get("config")
      response.body
      puts "Hue Configuration:"
      ap(response.body)
  end

  # ----------------------------------------------------------------------

  desc "groups", "Find out detail on your hue groups"
  def groups
      puts "Getting all the groups."

      webinit

      response = @conn.get("groups")
      response.body
      puts "Hue Configuration:"
      ap(response.body)
  end

  # ----------------------------------------------------------------------

  desc "lights", "Find out detail on your entire hue light configuration"
  def lights
      puts "Getting details for all the lights."

      webinit

      response = @conn.get("lights")
      response.body
      puts "Hue Configuration:"
      ap(response.body)
  end

  # ----------------------------------------------------------------------

  desc "light ID", "Find out detail on a single light"
  def light(id)
      puts "Getting all the configuration items."

      webinit

      response = @conn.get("lights/#{id}")
      response.body
      puts "Hue Configuration:"
      ap(response.body)
  end

  # ----------------------------------------------------------------------

  desc "animate IDs", "Animate specified lights"
  def animate(*ids)
    webinit
    ids.each do |id|
      response = @conn.get("lights/#{id}")
      response.body
      puts "Animating Light: #{response.body['name']} state: [#{response.body['state']['on']}]"
    end
    $light_ids = ids
    illuminate
  end

  # ----------------------------------------------------------------------

  desc "state ID", "Find a light's on/off and color state"
  def state(id)
      puts "Getting Light state for #{id}!"

      webinit

      response = @conn.get("lights/#{id}")
      response.body
      puts "Light Detail: state: #{response.body['state']['on']} - bri: #{response.body['state']['bri']} - sat: #{response.body['state']['sat']} - hue: #{response.body['state']['hue']} - xy: #{response.body['state']['xy']}"
  end

  # ----------------------------------------------------------------------

  desc "crackle ID", "Performs a crackling effect on a light"
  def crackle(id)

    crackle_color_xy = [0.6725,0.3230]

    # Sequence to set the on/off/durations of a crackle
    crackle_sequencer = [
      [true,2, 4],
      [false, 1, 0.2],
      [true, 1, 0.2],
      [false, 1, 0.1],
      [true, 1, 0.1],
      [false, 1, 0.2],
      [true, 1, 0.1],
      [false, 1, 0.2]
    ]

    webinit

    starttime = Time.now
    finishtime = Time.local(2021, 11, 7, 6, 0, 0)

    hue = "[#{crackle_color_xy[0]}, #{crackle_color_xy[1]}]"
    puts "Performs a crackling effect on light #{id} - #{crackle_color_xy}"
    response = @conn.put("lights/#{id}/state") do |req|
      req.body = {on: true, sat: 254, bri: 200, xy: [crackle_color_xy[0], crackle_color_xy[1]]}.to_json
    end

    while starttime < finishtime
      puts "Looping the Crackle: #{starttime}"
      crackle_sequencer.each do |crackle_tip|
        # puts "crackle_tip ... #{crackle_tip[0]} #{crackle_tip[1]} #{crackle_tip[2]}"
        response = @conn.put("lights/#{id}/state") do |req|
          req.body = {"on": crackle_tip[0], "transitiontime": crackle_tip[1], sat: 254, bri: 200, xy: [crackle_color_xy[0], crackle_color_xy[1]]}.to_json
        end
        sleep crackle_tip[2]
      end
      starttime = Time.now
    end
  end

  # ----------------------------------------------------------------------

  private

  def illuminate

      webinit

      starttime = Time.now
      finishtime = Time.local(2021, 11, 7, 6, 0, 0)

      while starttime < finishtime
        # puts " Current Time: #{starttime}"
        # puts "Turn Off Time: #{finishtime}"
        $selected_colors_xy.each do |current_color|
          $light_ids.each do |target_light|
            hue = "[#{current_color[0]}, #{current_color[1]}]"
            puts "Target Light: #{target_light} - #{current_color} - #{hue}"
            response = @conn.put("lights/#{target_light}/state") do |req|
              req.body = {on: true, "transitiontime": 50, sat: 254, bri: 200, xy: [current_color[0], current_color[1]]}.to_json
            end
            # puts "RESPONSE CODE : #{response.code}"
            # puts "RESPONSE BODY : #{response.body}"
          end
          sleep 10
          starttime = Time.now
        end

      end
  end

  # ----------------------------------------------------------------------

  def webinit
      @conn = Faraday.new(url: $hub_uri) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json
        faraday.ssl.verify = false
      end
      # puts "Conncection Options: #{@conn.options}"
      # puts "Conncection SSL: #{@conn.ssl}"
      # puts "Conncection Params: #{@conn.params}"
      # puts "Conncection Headers: #{@conn.headers}"
      # puts "Conncection URL Prefix: #{@conn.url_prefix.path}"
  end

end

HueControler.start