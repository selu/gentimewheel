module GenTimeWheel
  class Zone
    @@zones = []

    def initialize(zone)
      @tz = TZInfo::Timezone.get(zone)
      @current_offset = @tz.period_for_utc(Time.now.utc).utc_total_offset
      @@zones << self
    end

    def base_rotate
      @current_offset/240.0        # 360/86400
    end

    def label
      "%s — UTC%+02d:%02d" % [@tz.to_s, @current_offset/3600, @current_offset%3600]
    end

    def generate(svg, radius)
      svg.g(stroke:"green", "stroke-width":3) do |g|
        g.defs do |defs|
          tradius = radius-35
          defs.path(d:"M #{-tradius} 0 A #{tradius} #{tradius} 0 0,1 #{tradius} 0", id:"path#{@tz.name}")
        end
        g.circle(r:radius, fill:"white")
        g.use("xlink:href":"#path#{@tz.name}", fill:"none", stroke:"red", "stroke-width":1)
        g.text(fill:"black", stroke:"none") do |text|
          text.textPath(label, "xlink:href":"#path#{@tz.name}")
        end
        24.times do |hour|
          g.g(transform:"rotate(#{15*hour-base_rotate}) translate(0,#{-radius})") do |gh|
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
