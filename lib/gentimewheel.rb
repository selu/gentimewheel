require 'builder'
require "tzinfo"
require "gentimewheel/version"
require "gentimewheel/zone"

module GenTimeWheel
  SIZE = 600

  def self.generate(zones,output)
    file = File.open(output, "w") if output
    builder = Builder::XmlMarkup.new(indent: 2, target: output ? file : STDOUT)

    builder.instruct! :xml
    builder.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
    builder.svg(xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink", width:SIZE, height:SIZE) do |svg|
      radius = SIZE/2-10
      svg.g(transform:"translate(#{SIZE/2},#{SIZE/2})") do |g|
        zones.each do |zone|
          zone.generate(g,radius)
          radius -= 60
        end
      end
    end

    file.close if output
  end
end
