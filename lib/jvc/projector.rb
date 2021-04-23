require 'socket'

require 'jvc/projector/constants'

module JVC
  class Projector
    attr_reader :rc_code
    attr_reader :model,
      :version,
      :installation_mode_names,
      :picture_mode_names
    # custom reading code
    attr_reader :horizontal_frequency, 
      :vertical_frequency,
      :color_depth,
      :color_model,
      :color_space,
      :hdr

    def initialize(port)
      @rc_code = RC_CODE_A
      @port = port
      reconnect
      request("MD")
    end

    def close
      @io&.close
      @io = nil
      @buffer = ""
    end

    def rc_code=(code)
      raise ArgumentError, "Unrecognized RC Code" unless [RC_CODE_A, RC_CODE_B].include?(code)
      @rc_code = code
      command("SURC", code == RC_CODE_A ? "0" : "1")
    end

    def power=(on)
      raise ArgumentError("not a boolean") unless [true, false].include?(on)
      command("PW", on ? "1" : "0")
    end

    def next_input
      command("IP", "+")
    end

    def previous_input
      command("IP", "-")
    end

    def rc(code)
      raise ArgumentError("unrecognized rc code") unless RC.key?(code)
      command("RC", "%02X%02X" % [rc_code, RC[code]])
    end

    def installation_mode=(mode)
      raise ArgumentError("invalid mode index") unless (1..10).include?(mode)
      mode -= 1
      # this can take a _really_ long time
      command("IN", "ML#{mode}", timeout: 30)
    end

    # have to overwrite because 2 is on
    def mask=(on)
      raise ArgumentError("not a boolean") unless [true, false].include?(on)
      command("ISMA", on ? "1" : "2")
      request("IS", "MA")
    end

    def resolution
      "#{horizontal_resolution}x#{vertical_resolution}" if horizontal_resolution && vertical_resolution
    end

    def on_update(&block)
      @notifier = block
    end

    def update
      request("PW")
      return unless power == :on
      
      unless version
        request("IF", "SV") 
        update_picture_mode
        update_input_signal
        update_installation
        update_display_setup
        update_function
      end

      unless @installation_mode_names
        @installation_mode_names = []
        (1..10).each do |i|
          request("IN", "M#{i.to_s(16).upcase}")
        end

        @picture_mode_names = []
        (1..6).each do |i|
          request("PM", "U#{i.to_s(16).upcase}")
        end
      end

      request("IP")
      request("IF", "IS")

      if source && source != :no_signal
        request("IF", %w{RH RV FH FV DC XB CM HR})
      else
        @horizontal_resolution =
          @vertical_resolution =
          @horizontal_frequency =
          @vertical_frequency =
          @color_depth =
          @color_model = 
          @color_space =
          @hdr = nil
      end
      request("IF", %w{LT MC MF})
    end

    private

    def reconnect
      close

      uri = URI.parse(@port)
      @io = if uri.scheme == "tcp"
        require 'socket'
        @io = TCPSocket.new(uri.host, uri.port || 20554)

        raise "no PJ_OK" unless @io.wait_readable(0.25)
        raise "no PJ_OK" unless @io.read(5) == "PJ_OK"
        @io.write("PJREQ")
        raise "no PJACK" unless @io.read(5) == "PJACK"
        @io
      elsif uri.scheme == "telnet" || uri.scheme == "rfc2217"
        require 'net/telnet/rfc2217'
        Net::Telnet::RFC2217.new('Host' => uri.host,
         'Port' => uri.port || 23,
         'baud' => 4800,
         'parity' => Net::Telnet::RFC2217::ODD)
      else
        require 'ccutrer-serialport'
        CCutrer::SerialPort.new(@port, baud: 19200, data_bits: 8, parity: :none, stop_bits: 1)
      end
    end

    def update_picture_mode
      # CC NR CM LA US RP TM TL
      request("PM", %w{PM DI PR CN BR CO TI LL ME LP GM EN ST PM})
    end

    def update_input_signal
      # 3P CS
      request("IS", %w{IL HS 3D AS MA LV})
    end

    def update_installation
      request("IN", %w{IS VS HA IP LL KV})
    end

    def update_display_setup
      request("DS", %w{BC MP SD LO LA})
    end

    def update_function
      # OT
      request("FU", %w{TR EM CF})
    end

    def request(command, subcommands = nil)
      if subcommands.is_a?(Array)
        subcommands.each { |sc| request(command, sc) }
        return
      end

      @pending_response = subcommands || true
      message("?", command, subcommands, timeout: 1)
    end

    def command(cmd, args = nil, timeout: nil)
      @pending_response = nil
      message("!", cmd, args, timeout: timeout || 10)
    end

    def message(type, command, args = nil, timeout: nil)
      message = "#{type}\x89\x01#{command}#{args}\n"
      puts "writing #{message.inspect}"
      @io.write(message)
      wait_for_response(timeout)
    end

    def wait_for_response(timeout)
      read(timeout)
      while @io.ready? || @pending_response
        timeout ||= 1
        read(timeout)
      end
    end

    BOOLEAN_IVS = {
      "PMLL" => :low_latency,
      "PMUS" => :eshift_8k,
      "PMTM" => :auto_tone_mapping,
      "PMCB" => :color_management,

      "ISMA" => :mask,

      "INHA" => :high_altitude_mode,
      "INIP" => :image_pattern,
      "INLL" => :lens_lock,

      "DSSD" => :source_display,
      "DSLO" => :logo,

      "FUEM" => :eco_mode,
      "FUCF" => :sddp,
    }
    private_constant :BOOLEAN_IVS

    INTEGER_IVS = {
      "PMCN" => :contrast,
      "PMBR" => :brightness,
      "PMCO" => :color,
      "PMTI" => :tint,
      "PMRN" => :noise_reduction,
      "PMEN" => :enhance,
      "PMST" => :smoothing,
      "PMTL" => :mapping_level,

      # this is coming back as a single byte?
      "IS3P" => :phase_adjustment_3d,
      "ISLV" => :parallax_3d,

      "INKV" => :keystone,
      "INML" => :installation_mode,

      # this is coming back as a single byte?
      "FUOT" => :off_timer,

      "IFRH" => :horizontal_resolution,
      "IFRV" => :vertical_resolution,
      "IFLT" => :lamp_time,
      "IFMC" => :max_cll,
      "IFMF" => :max_fall,
    }
    private_constant :INTEGER_IVS

    ENUM_IVS = {
      "PW" => :power,
      "IP" => :input,
      "TS" => :test_pattern,

      "PMPM" => :picture_mode,
      "PMDI" => :intelligent_lens_aperture,
      "PMPR" => :color_profile,
      "PMCC" => :color_temperature_correction,
      "PMCM" => :clear_motion_drive,
      "PMGC" => :gamma_correction,
      "PMGM" => :graphic_mode,
      "PMME" => :motion_enhance,
      "PMLP" => :lamp_power,

      "ISAS" => :aspect,
      "ISHS" => :hdmi_color_space,
      "ISIL" => :input_level,
      "IS3D" => :mode_3d,

      "INIS" => :installation_style,
      "INVS" => :anamorphic,

      "DSBC" => :background_color,
      "DSMP" => :menu_position,
      "DSLA" => :language,

      "FUTR" => :trigger,

      "IFIS" => :source,    
    }
    private_constant :ENUM_IVS

    def self.split_command(command)
      if command.length == 2
        command.inspect
      else
        "#{command[0..1].inspect}, #{command[2..3].inspect}"
      end
    end

    module GeneratedMethods
    end
    include GeneratedMethods

    BOOLEAN_IVS.each do |(command, name)|
      attr_reader name
      public name

      GeneratedMethods.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}=(value)
          raise ArgumentError.new("expected boolean for #{name}") unless [true, false].include?(value)
          command(#{command.inspect}, value ? '1' : '0')
          request(#{split_command(command)})
        end
      RUBY
    end

    INTEGER_IVS.each do |(command, name)|
      attr_reader name
      public name
      next if command[0..1] == "IF"

      GeneratedMethods.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}=(value)
          raise ArgumentError.new("Invalid value \#{value} for #{name}") if (r = RANGES[#{name.inspect}]) && !r.include?(value)
          command(#{command.inspect}, from_integer(value))
          request(#{split_command(command)})
        end
      RUBY
    end

    ENUM_IVS.each do |(command, name)|
      attr_reader name
      public name

      next if command[0..1] == "IF"
      # returns an enum, but assigns a boolean
      next if command == "PW"

      mapping = name.upcase
      width = const_get(mapping, false).values.max.to_s(16).length
      GeneratedMethods.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}=(value)
          raise ArgumentError.new("Invalid value \#{value.inspect} for #{name}") unless #{mapping}.key?(value)
          command(#{command.inspect}, "%0#{width}X" % #{mapping}[value])
          request(#{split_command(command)})
        end
      RUBY
    end

    MODELS = {
      "ILAFPJ -- -XH4" => "DLA-HD350",
      "ILAFPJ -- -XH7" => "DLA-RS10",
      "ILAFPJ -- -XH5" => "DLA-HD750/RS20",
      "ILAFPJ -- -XH8" => "DLA-HD550",
      "ILAFPJ -- -XHA" => "DLA-RS15",
      "ILAFPJ -- -XH9" => "DLA-HD950/HD990/RS25/RS35",
      "ILAFPJ -- -XHB" => "DLA-X3/RS40",
      "ILAFPJ -- -XHC" => "DLA-X7/X9/RS50/RS60",
      "ILAFPJ -- -XHE" => "DLA-X30/RS45",
      "ILAFPJ -- -XHF" => "DLA-X70R/X90R/RS55/RS65",
      "ILAFPJ -- B2A1" => "DLA-NX9/RS3000",
      "ILAFPJ -- B2A2" => "DLA-NX7/RS2000",
      "ILAFPJ -- B2A3" => "DLA-NX5/RS1000",
    }.freeze
    private_constant :MODELS

    def read(timeout = nil)
      if @io.wait_readable(timeout).nil?
        puts "timed out waiting for read"
        @pending_response = nil
        return
      end
      @buffer.concat(@io.readline)
      return unless @buffer[-1] == "\n"
      line, @buffer = @buffer, ""
        
      raise "message too short: #{line.inspect}" unless line.length >= 6
      raise "unrecognized id #{line[1..2].inspect}" unless line[1..2] == "\x89\x01".force_encoding(line.encoding)

      cmd = line[3..4]
      args = line[5..-2]

      case line[0]
      when "\x06"
        raise "line too long" unless line.length == 6
        puts "ack: #{cmd.inspect}"
        if cmd == "PM" && @pending_response != true && @pending_response =~ /^U(\X)$/
          @picture_mode_names[$1.to_i(16) - 1] = readbytes(10).strip
          @pending_response = nil
        end
        if cmd == "IN" && @pending_response != true && @pending_response =~ /^M(\X)$/
          @installation_mode_names[$1.to_i(16) - 1] = readbytes(10).strip
          @pending_response = nil
        end
      when "@"
        puts "response to #{cmd}: #{args.inspect}"
        pending_response_str = @pending_response.is_a?(String) ? @pending_response : nil
        # generic processing
        if @pending_response && args.length == 4 && (iv = INTEGER_IVS["#{cmd}#{pending_response_str}"])
          @pending_response = nil
          assign(iv, to_integer(args))
          return
        elsif @pending_response && args.length == 1 && (iv = BOOLEAN_IVS["#{cmd}#{pending_response_str}"])
          @pending_response = nil
          assign(iv, args == '1')
          return
        elsif (iv = ENUM_IVS["#{cmd}#{pending_response_str}"])
          @pending_response = nil
          mapping = self.class.const_get(iv.upcase, false)
          assign(iv, mapping.invert[args.to_i(16)])
          return
        end
  
        case cmd
        when "MD"
          assign(:model, MODELS[args] || args)
          puts "got model #{@model.inspect}"
        when "IF"
          case @pending_response
          when "FH"
            raise "line too long" unless args.length == 4
            assign(:horizontal_frequency, to_integer(args).to_f / 100)
          when "FV"
            raise "line too long" unless args.length == 4
            assign(:vertical_frequency, to_integer(args).to_f / 100)
          when "DC"
            raise "line too long" unless args.length == 1
            assign(:color_depth, case args
              when "0"; 8
              when "1"; 10
              when "2"; 12
            end)
          when "XV"
            raise "line too long" unless args.length == 1
            assign(:color_model, case args
              when "0"; :rgb
              when "1"; :yuv
            end)
          when "SV"
            raise "line too long" unless args.length == 6
            assign(:version, args.strip)
          when "CM"
            raise "line too long" unless args.length == 1
            assign(:color_space, [
              "No Data",
              "BT.601",
              "BT.709",
              "xvYCC601",
              "xvYCC709",
              "sYCC601",
              "Adobe YCC601",
              "Adobe RGB",
              "BT.2020 Constant Luminance",
              "BT.2020 Non-Constant Luminance",
              "Other",
            ][args.to_i(16)])
          when "HR"
            raise "line too long" unless args.length == 1
            assign(:hdr, case args
              when "0"; "SDR"
              when "1"; "HDR"
              when "2"; "SMTPE ST 2084"
              when "F"; "None"
            end)
          else
            raise "unrecognized IF response #{@pending_response}"
          end
        else
          raise "unrecognized response #{cmd}"
        end
        @pending_response = false
      else
        raise "unrecognized message type #{line[0].inspect}"
      end
    end

    def readbytes(length)
      result = +''
      while result.length < length
        @io.wait_readable
        result += @io.read(length - result.length)
      end
      result
    end

    def assign(iv, value)
      instance_variable_set(:"@#{iv}", value)
      @notifier&.call(iv, value)
    end

    def to_integer(str)
      # first convert the ascii string representation of hex
      # to binary, then interpret that as a 16-bit big endian
      # number
      [str].pack("H*").unpack("s>").first
    end

    def from_integer(int)
      [int].pack("s>").unpack("H*").first
    end
  end
end
