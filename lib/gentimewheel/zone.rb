module GenTimeWheel
  class Zone
    @@zones = []

    def initialize(zone)
      @tz = TZInfo::Timezone.get(zone)
      @@zones << self
    end

    def generate(svg, radius)
      svg.g(stroke:"green", "stroke-width":3) do |g|
        g.circle(r:radius, fill:"white")
        24.times do |hour|
          g.g(transform:"rotate(#{15*hour}) translate(0,#{-radius})") do |gh|
            gh.line(y2: 10)
            gh.text(hour, y:24, fill:"green", stroke:"none", "text-anchor":"middle")
          end
        end
      end
    end

    def self.zones
      @@zones
    end
  end
end
