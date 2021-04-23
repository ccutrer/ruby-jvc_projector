require 'homie-mqtt'

module JVC
  class Projector
    module CLI
      class MQTT
        attr_reader :projector, :homie

        def initialize(projector, homie)
          @projector = projector
          @homie = homie
          @mutex = Mutex.new
          pj = nil

          homie.node("projector", "Projector", projector.model) do |p|
            pj = p
            pj.property("power-boolean", "Power (on/off)", :boolean, projector.power != :off) do |value|
              synchronize { projector.power = value }
            end
            pj.property("power", "Power state", :enum, projector.power, format: POWER.keys)

            pj.property("input", "Input", :enum, projector.input, format: INPUT.keys + %w{next previous}) do |value|
              synchronize do
                case value
                when 'next'; projector.next_input
                when 'previous'; projector.previous_input
                else; projector.input = value.to_sym
                end
              end
            end

            pj.property("input-integer", "Input as integer", :integer, INPUT[projector.input], format: 0..7) do |value|
              value = INPUT.invert[value]
              next unless value
              synchronize { projector.input = value }
            end

            pj.property("rc-code", "Remote Control Code", :enum, projector.rc_code == RC_CODE_B ? 'b' : 'a', format: %w{a b}) do |value|
              synchronize { projector.rc_code = value == 'a' ? RC_CODE_A : RC_CODE_B }
            end

            pj.property("rc", "Send a remote control command", :enum, format: RC.keys, retained: false) do |value|
              synchronize { projector.rc(value.to_sym) }
            end

            pj.property("source", "Source Video Format", :enum, projector.source, format: SOURCE.keys)
            pj.property("resolution", "Resolution (WxH)", :string, projector.resolution)
            pj.property("color-depth", "Color Bit Depth", :enum, projector.color_depth, format: [8, 10, 12])
            pj.property("color-model", "Color Model", :enum, projector.color_model, format: %w{rgb yuv})
            pj.property("color-space", "Color Space", :string, projector.color_space)
            pj.property("hdr", "HDR Mode", :string, projector.hdr)
            pj.property("lamp-time", "Lamp Time", :integer, projector.lamp_time, unit: "H")
            pj.property("max-cll", "Maximum Content Light Level", :integer, projector.max_cll, unit: "nits")
            pj.property("max-fall", "Maximum Frame Average Light Level", :integer, projector.max_fall, unit: "nits")

            pj.property("3d-mode", "3D Mode", :enum, projector.mode_3d, format: MODE_3D.keys) do |value|
              synchronize { projector.mode_3d = value.to_sym }
            end

            pj.property("3d-parallax", "3D Parallax", :integer, projector.parallax_3d, format: RANGES[:parallax_3d]) do |value|
              synchronize { projector.parallax_3d = value }
            end

            pj.property("3d-phase-adjustment", "3D Phase Adjustment", :integer, projector.phase_adjustment_3d) do |value|
              synchronize { projector.phase_adjustment_3d = value }
            end

            pj.property("8k-eshift", "8K E-Shift", :boolean, projector.eshift_8k) do |value|
              synchronize { projector.eshift_8k = value }
            end

            pj.property("anamorphic", "Anamorphic Mode", :enum, projector.anamorphic, format: ANAMORPHIC.keys) do |value|
              synchronize { projector.anamorphic = value.to_sym }
            end

            pj.property("aspect", "Aspect (Zoom)", :enum, projector.aspect, format: ASPECT.keys) do |value|
              synchronize { projector.aspect = value.to_sym }
            end

            pj.property("auto-tone-mapping", "Auto Tone Mapping", :boolean, projector.auto_tone_mapping) do |value|
              synchronize { projector.auto_tone_mapping = value }
            end

            pj.property("background-color", "Background Color", :enum, projector.background_color, format: BACKGROUND_COLOR.keys) do |value|
              synchronize { projector.background_color = value.to_sym }
            end

            pj.property("clear-motion-drive", "Clear Motion Drive", :enum, projector.clear_motion_drive, format: CLEAR_MOTION_DRIVE.keys) do |value|
              synchronize { projector.clear_motion_drive = value.to_sym }
            end

            pj.property("color-management", "Color Management", :boolean, projector.color_management) do |value|
              synchronize { projector.color_management = value }
            end

            pj.property("color-profile", "Color Profile", :enum, projector.color_profile, format: COLOR_PROFILE.keys) do |value|
              synchronize { projector.color_profile = value.to_sym }
            end

            pj.property("color-temperature-correction", "Color Temperature Correction", :enum, projector.color_temperature_correction, format: COLOR_TEMPERATURE_CORRECTION.keys) do |value|
              synchronize { projector.color_temperature_correction = value.to_sym }
            end

            pj.property("eco-mode", "Eco Mode", :boolean, projector.eco_mode) do |value|
              synchronize { projector.eco_mode = value }
            end

            pj.property("gamma-correction", "Gamma Correction", :enum, projector.gamma_correction, format: GAMMA_CORRECTION.keys) do |value|
              synchronize { projector.gamma_correction = value.to_sym }
            end

            pj.property("graphic-mode", "Graphic Mode", :enum, projector.graphic_mode, format: GRAPHIC_MODE.keys) do |value|
              synchronize { projector.graphic_mode = value.to_sym }
            end

            pj.property("high-altitude-mode", "High Altitude Mode", :boolean, projector.high_altitude_mode) do |value|
              synchronize { projector.high_altitude_mode = value }
            end

            pj.property("image-pattern", "Adjustment Image Pattern", :boolean, projector.image_pattern) do |value|
              synchronize { projector.image_pattern = value }
            end

            pj.property("input-level", "Dynamic Range Input Level", :enum, projector.input_level, format: INPUT_LEVEL.keys) do |value|
              synchronize { projector.input_level = value.to_sym }
            end

            pj.property("installation-mode", "Installation Mode (Lens Memory)", :integer, retained: false, format: 1..10) do |value|
              begin
                synchronize { projector.installation_mode = value }
              rescue => e
                puts "failed setting things #{e}"
              end
            end

            pj.property("installation-style", "Installation Style", :enum, projector.installation_style, format: INSTALLATION_STYLE.keys) do |value|
              synchronize { projector.installation_style = value.to_sym }
            end

            pj.property("intelligent-lens-aperture", "Intelligent Lens Aperture", :enum, projector.intelligent_lens_aperture, format: INTELLIGENT_LENS_APERTURE.keys) do |value|
              synchronize { projector.intelligent_lens_aperture = value.to_sym }
            end

            pj.property("keystone", "Keystone", :integer, projector.keystone, format: RANGES[:keystone]) do |value|
              synchronize { projector.keystone = value }
            end

            pj.property("lamp-power", "Lamp Power", :enum, projector.lamp_power, format: LAMP_POWER.keys) do |value|
              synchronize { projector.lamp_power = value.to_sym }
            end

            pj.property("language", "Language", :enum, projector.language, format: LANGUAGE.keys) do |value|
              synchronize { projector.language = value.to_sym }
            end

            pj.property("lens-lock", "Lens Lock", :boolean, projector.lens_lock) do |value|
              synchronize { projector.lens_lock = value }
            end

            pj.property("logo", "Logo Display at Boot", :boolean, projector.logo) do |value|
              synchronize { projector.logo = value }
            end

            pj.property("low-latency", "Low Latency Mode", :boolean, projector.low_latency) do |value|
              synchronize { projector.low_latency = value }
            end

            pj.property("mapping-level", "Auto Tone Mapping Mapping Level", :integer, projector.mapping_level, format: 0..0xffff) do |value|
              synchronize { projector.mapping_level = value }
            end

            pj.property("mask", "Mask", :boolean, projector.mask) do |value|
              synchronize { projector.mask = value }
            end

            pj.property("menu-position", "Menu Position", :enum, projector.menu_position, format: MENU_POSITION.keys) do |value|
              synchronize { projector.menu_position = value.to_sym }
            end

            pj.property("motion-enhance", "Motion Enhance", :enum, projector.motion_enhance, format: MOTION_ENHANCE.keys) do |value|
              synchronize { projector.motion_enhance = value.to_sym }
            end

            pj.property("off-timer", "Off Timer", :integer, projector.off_timer, format: 0..4, unit: "H") do |value|
              synchronize { projector.off_timer = value }
            end

            pj.property("picture-mode", "Picture Mode", :enum, projector.picture_mode, format: PICTURE_MODE.keys) do |value|
              synchronize { projector.picture_mode = value.to_sym }
            end

            pj.property("sddp", "Control4 SDDP", :boolean, projector.sddp) do |value|
              synchronize { projector.sddp = value }
            end

            pj.property("source-display", "Display source on screen", :boolean, projector.source_display) do |value|
              synchronize { projector.source_display = value }
            end

            pj.property("test-pattern", "Test Pattern", :enum, projector.test_pattern, format: TEST_PATTERN.keys) do |value|
              synchronize { projector.test_pattern = value.to_sym }
            end

            pj.property("trigger", "Trigger Mode", :enum, projector.trigger, format: TRIGGER.keys) do |value|
              synchronize { projector.trigger = value.to_sym }
            end

            # not published yet:
            # installation mode names
          end

          homie.publish

          projector.on_update do |property, new_value|
            property = "3d-mode" if property == :mode_3d
            property = "3d-parallax" if property == :parallax_3d
            property = "3d-phase-adjustment" if property == :phase_adjustment_3d
            property = "8k-eshift" if property == :eshift_8k

            if property == :rc_code
              new_value = new_value == RC_CODE_A ? 'a' : 'b'
            end

            pj[property.to_s.gsub("_", "-")]&.value = new_value

            if %i{horizontal_resolution vertical_resolution}.include?(property)
              pj["resolution"].value = projector.resolution
            end
            if property == :power
              pj["power-boolean"].value = new_value != :off
            end
            if property == :input
              pj["input-integer"].value = INPUT[new_value]
            end
          end

          loop do
            begin
              synchronize do
                projector.update
              end
            rescue => e
              puts "failed updating: #{e}"
            end
            sleep 1
          end
        end

        private

        def synchronize(&block)
          @mutex.synchronize(&block)
        end
      end
    end
  end
end
