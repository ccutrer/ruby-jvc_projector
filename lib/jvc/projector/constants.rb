module JVC
  class Projector
    RC_CODE_A = 0x73
    RC_CODE_B = 0x63

    POWER = {
      off: 0,
      on: 1,
      cooling: 2,
      warming: 3,
      emergency: 4,
    }.freeze

    INPUT = {
      s_video: 0,
      video: 1,
      component: 2,
      pc: 3,
      hdmi1: 6,
      hdmi2: 7
    }.freeze

    HDMI_COLOR_SPACE = {
      auto: 0,
      "YCbCr(4:4:4)": 1,
      "YCbCr(4:2:2)": 2,
      RGB: 3,
    }

    RC = {
      "3d_format_auto": 0xdb, # RS1000/2000/3000/NX5/7/9
      "3d_format_cycle": 0xd6, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      "3d_format_sxs": 0xdc, # RS1000/2000/3000/NX5/7/9
      "3d_format_off": 0xde, # RS1000/2000/3000/NX5/7/9
      "3d_format_tab": 0xdd, # RS1000/2000/3000/NX5/7/9
      "3d_settings": 0xd5, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      advanced_picture_adjust: 0x73, # HD550/950/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      anamorphic_a: 0x23, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      anamorphic_b: 0x2b, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      anamorphic_c: 0x33, # RS1000/2000/3000/NX5/7/9
      anamorphic_cycle: 0xc5, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      anamorphic_off: 0x24, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      aspect_cycle: 0x77,
      aspect_16x9: 0x26,
      aspect_4x3: 0x25,
      aspect_zoom: 0x27,
      aspect_auto: 0xae, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      aspect_pc_full: 0xb0, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      aspect_just: 0xaf, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      auto_align: 0x13, # PC input on HD750/950/990/X7/X9/X70/X90/RS20/25/35/50/60/55/65
      auto_lens_center: 0xc9, # X3/X7/X9/X70/X90/RS50/60/45/55/65
      back: 0x03,
      bnr_off: 0x10,
      bnr_on: 0x0f,
      bright_level_minus: 0xa3, # X7/X9/X70/X90/RS50/60/55/65
      bright_level_plus: 0xa2, # X7/X9/X70/X90/RS50/60/55/65
      brightness_minus: 0x7b,
      brightness_plus: 0x7a,
      brightness_adjust: 0x09,
      cec_off: 0x57,
      cec_on: 0x56,
      clear_motion_drive_cycle: 0x8a, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      clear_motion_drive_off: 0x47, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      clear_motion_drive_high: 0x49, # RS1000/2000/3000/NX5/7/9
      clear_motion_drive_low: 0x48, # RS1000/2000/3000/NX5/7/9
      clear_motion_drive_mode1: 0xce, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      clear_motion_drive_mode2: 0xcf, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      clear_motion_drive_mode3: 0x48, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      clear_motion_drive_mode4: 0x49, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      clear_motion_drive_inverse_telecine: 0x4a, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      color_minus: 0x7d,
      color_plus: 0x7c,
      color_adjust: 0x15,
      color_management_off: 0x60, # HD750/950/990/ X7/X9/RS20/25/35/50/60/55/65
      color_management_custom1: 0x61, # HD750/950/990/ X7/X9/RS20/25/35/50/60/55/65
      color_management_custom2: 0x62, # HD750/950/990/ X7/X9/RS20/25/35/50/60/55/65
      color_management_custom3: 0x63, # HD750/950/990/ X7/X9/RS20/25/35/50/60/55/65
      color_management_cycle: 0x89, # X7/X9/X70/X90/RS50/60/55/65
      color_profile_cycle: 0x88, # X7/X9/X70/X90/RS50/60/55/65/1000/2000/3000/NX5/7/9
      color_space_cycle: 0xcd, # X3/X30/RS40/RS45
      color_temp_5800k: 0x4e, # HD350/550/750/950/990/RS10/15/20/25/35
      color_temp_6500k: 0x4f,
      color_temp_7500k: 0x50, # HD350/550/750/950/990/RS10/15/20/25/35
      color_temp_9300k: 0x51, # HD350/550/750/950/990/RS10/15/20/25/35
      color_temp_custom1: 0x53,
      color_temp_custom2: 0x54,
      color_temp_custom3: 0x55,
      color_temp_cycle: 0x76,
      color_temp_high_bright: 0x52, # HD350/550/750/ 950/990/X3/X30/RS10/15/20/25/35/40/45
      color_temp_gain_blue_minus: 0x91, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_gain_blue_plus: 0x90, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_gain_green_minus: 0x8f, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_gain_green_plus: 0x8e, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_gain_red_minus: 0x8d, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_gain_red_plus: 0x8c, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_blue_minus: 0x97, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_blue_plus: 0x96, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_green_minus: 0x95, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_green_plus: 0x94, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_red_minus: 0x93, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_temp_offset_red_plus: 0x92, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      color_transient_improvement_off: 0x5c, # HD350/550/750/950/990/RS10/15/20/25/35
      color_transient_improvement_low: 0x5d, # HD350/550/750/950/990/RS10/15/20/25/35
      color_transient_improvement_middle: 0x5e, # HD350/550/750/950/990/RS10/15/20/25/35
      color_transient_improvement_high: 0x5f, # HD350/550/750/950/990/RS10/15/20/25/35
      contrast_minus: 0x79,
      contrast_plus: 0x78,
      contrast_adjust: 0x0a,
      cursor_down: 0x02,
      cursor_left: 0x36,
      cursor_right: 0x34,
      cursor_up: 0x01,
      dark_level_minus: 0xa5, # X7/X9/X70/X90/RS50/60/55/65
      dark_level_plus: 0xa4, # X7/X9/X70/X90/RS50/60/55/65
      detail_enhance_minus: 0x12,
      detail_enhance_plus: 0x11,
      gamma_a: 0x39,
      gamma_b: 0x3a,
      gamma_c: 0x3b,
      gamma_custom1: 0x3c,
      gamma_custom2: 0x3d,
      gamma_custom3: 0x3e,
      gamma_d: 0x3f, # HD550/950/990/X3/X7/X9/ X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      gamma_normal: 0x38,
      gamma_cycle: 0x75,
      gamma_settings: 0xf5, # RS1000/2000/3000/NX5/NX7/NX9
      hide_off: 0xd1, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      hide_on: 0xd0, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      hide_toggle: 0x1d,
      horizontal_position_minus: 0xab, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      horizontal_position_plus: 0xaa, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      information: 0x74,
      input_component: 0x4d,
      input_hdmi1: 0x70,
      input_hdmi2: 0x71,
      input_pc: 0x46, # HD750/950/990/X7/X9/X70/X90 RS20/25/35/50/60/55/65
      input_s_video: 0x4c, # HD350/550/750/950/990
      input_video: 0x4b, # HD350/550/750/950/990
      input_cycle: 0x08,
      isf_day: 0x64, # X7/X9/X70/X90/RS50/60/55/65
      isf_night: 0x65, # X7/X9/X70/X90/RS50/60/55/65
      isf_off: 0x5a, # HD950/990/X7/X9/X70/X90/RS25/35/50/60/55/65
      isf_on: 0x5b, # HD950/990/X7/X9/X70/X90/ RS25/35/50/60/55/65
      keystone_correction_horizontal_minus: 0x41,
      keystone_correction_horizontal_plus: 0x40,
      keystone_correction_vertical_minus: 0x1c,
      keystone_correction_vertical_plus: 0x1b,
      lens_aperture1: 0x28, # HD350/HD550
      lens_aperture2: 0x29, # HD350/HD550
      lens_aperture3: 0x2a, # HD350/HD550
      lens_aperture_minus: 0x1f, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      lens_aperture_plus: 0x1e, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      lens_aperture_adjust: 0x20, # HD350/750/950/990/RS10/20/25/35/1000/2000/3000/NX5/7/9
      lens_aperture_cycle: 0x20, # HD550/RS15
      lens_control_cycle: 0x30,
      lens_focus_minus: 0x32,
      lens_focus_plus: 0x31,
      lens_memory_cycle: 0xd4, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      lens_memory_1: 0xd8, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      lens_memory_2: 0xd9, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      lens_memory_3: 0xda, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      lens_memory_4: 0xe5, # RS1000/2000/3000/NX5/7/9
      lens_memory_5: 0xe6, # RS1000/2000/3000/NX5/7/9
      lens_memory_6: 0xe7, # RS1000/2000/3000/NX5/7/9
      lens_memory_7: 0xe8, # RS1000/2000/3000/NX5/7/9
      lens_memory_8: 0xe9, # RS1000/2000/3000/NX5/7/9
      lens_memory_9: 0xea, # RS1000/2000/3000/NX5/7/9
      lens_memory_10: 0xeb, # RS1000/2000/3000/NX5/7/9
      lens_shift_down: 0x22,
      lens_shift_left: 0x44,
      lens_shift_right: 0x43,
      lens_shift_up: 0x21,
      lens_zoom_in: 0x35,
      lens_zoom_out: 0x37,
      low_latency: 0xf8, # RS1000/2000/3000/NX5/NX7/NX9
      mask_bottom_minus: 0xb8, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_bottom_plus: 0xb7, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_left_minus: 0xb2, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_left_plus: 0xb1, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_right_minus: 0xb4, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_right_plus: 0xb3, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_top_minus: 0xb6, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      mask_top_plus: 0xb5, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      menu: 0x2e,
      menu_position: 0x42, # HD550/950/990/X3/X7/X9/ X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      mosquitto_noise_reduction_minus: 0x0e,
      mosquitto_noise_reduction_plus: 0x0d,
      mpc: 0xf0, # RS1000/2000/3000/NX5/NX7/NX9
      name_edit: 0xf7, # RS1000/2000/3000/NX5/NX7/NX9
      noise_reduction: 0x18, # HD350/550/750/950/990/RS10/15/20/25/35
      ok: 0x2f,
      phase_minus: 0xa90, # (PC Input) X7/X9/X70/X90/RS50/60/55/65
      phase_plus: 0xa8, # (PC Input) X7/X9/X70/X90/RS50/60/55/65
      picture_adjust: 0x72, # HD550/750/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      picture_mode_3d: 0x87, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      picture_mode_animation: 0x66, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      picture_mode_cinema: 0x68, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/1000/2000/3000/NX5/7/9
      picture_mode_cinema1: 0x69,
      picture_mode_cinema2: 0x68,
      picture_mode_cinema3: 0x66, # HD550/750/990/RS15/25/35
      picture_mode_setting: 0xf4, # RS1000/2000/3000/NX5/NX7/NX9
      picture_mode_dynamic: 0x6b, # HD350/550/750/950/990
      picture_mode_hdr10: 0xed, # RS1000/2000/3000/NX5/7/9
      picture_mode_hlg: 0xe1, # RS1000/2000/3000/NX5/7/9
      picture_mode_film: 0x69, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65/2000/3000/NX7/9
      picture_mode_natural: 0x6a,
      picture_mode_stage: 0x67,
      picture_mode_thx: 0x6f, # HD750/950/990/X7/X9/X70/X90/RS20/25/35/50/60/55/65/3000/NX9
      picture_mode_user1: 0x6c,
      picture_mode_user2: 0x6d,
      picture_mode_user3: 0x6e, # HD550/750/950/990/X3/X30/RS20/25/35/40/45/1000/2000/3000/NX5/7/9
      picture_mode_user4: 0xca, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      picture_mode_user5: 0xcb, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      picture_mode_user6: 0xcc, # RS1000/2000/3000/NX5/7/9
      picture_mode_user_cycle: 0xd7, # X30/X70/X90/RS45/55/65/1000/2000/3000/NX5/7/9
      picture_tone_blue_minus: 0xa1, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_blue_plus: 0xa0, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_green_minus: 0x9f, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_green_plus: 0x9e, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_red_minus: 0x9d, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_red_plus: 0x9c, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_white_minus: 0x9b, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      picture_tone_white_plus: 0x9a, # X7/X9/RS50/60 - Film Mode Only, X70/X90/RS55/65 - All Modes
      pixel_shift_horizontal_blue_minus: 0xbe, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_horizontal_blue_plus: 0xbd, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_horizontal_green_minus: 0xbc, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_horizontal_green_plus: 0xbb, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_horizontal_red_minus: 0xba, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_horizontal_red_plus: 0xb9, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_blue_minus: 0xc4, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_blue_plus: 0xc3, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_green_minus: 0xc2, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_green_plus: 0xc1, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_red_minus: 0xc0, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      pixel_shift_vertical_red_plus: 0xbf, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      power_off: 0x06, # Must send twice
      power_on: 0x05,
      random_noise_reduction_minus: 0x0c,
      random_noise_reduction_plus: 0x0b,
      screen_adjust_off: 0x80, # X3/X30/RS40/RS45
      screen_adjust_a: 0x81, # X3/X30/RS40/RS45
      screen_adjust_b: 0x82, # X3/X30/RS40/RS45
      screen_adjust_c: 0x83, # X3/X30/RS40/RS45
      setting_memory: 0xc4, # RS1000/2000/3000/NX5/NX7/NX9
      sharpness_minus: 0x7f,
      sharpness_plus: 0x7e,
      sharpness_adjust: 0x14,
      shutter_close: 0x19, # HD550/950/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      shutter_open: 0x1a, # HD550/950/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      shutter_off: 0x2d, # HD550/950/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      shutter_on: 0x2c, # HD550/950/990/X3/X7/X9/X30/X70/X90/RS15/25/35/40/50/60/45/55/65
      solenoid_normal: 0xd2, # (Only when no signal or displaying test pattern) RS2000/3000/NX7/9
      solenoid_wide: 0xd3, # (Only when no signal or displaying test pattern) RS2000/3000/NX7/9
      test_pattern_cycle: 0x59, # HD350/550/750/950/990/RS10/15/20/25/35
      thx_bright: 0x85, # X7/X9/X70/X90/RS50/60/55/65
      thx_dark: 0x86, # X7/X9/X70/X90/RS50/60/55/65
      thx_on: 0xc7, # X7/X9/X70/X90/RS50/60/55/65
      thx_off: 0xc8, # X7/X9/X70/X90/RS50/60/55/65
      tint_minus: 0x99, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      tint_plus: 0x98, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      tint_adjust: 0x16,
      tracking_minus: 0xa7, # (PC Input) X7/X9/X70/X90/RS50/60/55/65
      tracking_plus: 0xa6, # (PC Input) X7/X9/X70/X90/RS50/60/55/65
      vertical_position_minus: 0xad, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      vertical_position_plus: 0xac, # X3/X7/X9/X30/X70/X90/RS40/50/60/45/55/65
      vertical_stretch_off: 0x24, # HD350/750/950/990/RS10/20/25/35
      vertical_stretch_on: 0x23, # HD350/750/950/990/RS10/20/25/35
    }.freeze

    TEST_PATTERN = {
      off: 0x00,
      color_bars: 0x01,
      stair_step_bw: 0x06,
      stair_step_red: 0x07,
      stair_step_green: 0x08,
      stair_step_blue: 0x09,
      crosshatch_green: 0x0a
    }.freeze

    SOURCE = [nil, nil,
        "480p",
        "576p",
        "720p50",
        "720p60",
        "1080i50",
        "1080i60",
        "1080p24",
        "1080p50",
        "1080p60",
        :no_signal,
        "720p 3D",
        "1080i 3D",
        "1080p 3D",
        :out_of_range,
        "4K@60",
        "4K@50",
        "4K@30",
        "4K@25",
        "4K@24",
        "2160p60",
        "2160p50",
        "2160p30",
        "2160p25",
        "2160p24",
        nil,
        nil,
        "1080p25",
        "1080p30",
        "2K@24",
        "2K@25",
        "2K@30",
        "2K@50",
        "2K@60",
        "2160p120",
        "4K@120",
        "VGA",
        "SVGA",
        "XGA",
        "SXGA",
        "WXGA",
        "WXGA+",
        "WXSGA+",
        "WUXGA",
        "WXGA",
        "FWXGA",
        "WXGA++",
        "UXGA",
        "QXGA",
        "WQXGA"
    ].each_with_index.to_h.reject { |(k, v)| k.nil? }

    TRIGGER = {
      off: 0x0,
      power: 0x1,
      anamorphic: 0x2,
      installation_mode1: 0x3,
      installation_mode2: 0x4,
      installation_mode3: 0x5,
      installation_mode4: 0x6,
      installation_mode5: 0x7,
      installation_mode6: 0x8,
      installation_mode7: 0x9,
      installation_mode8: 0xa,
      installation_mode9: 0xb,
      installation_mode10: 0xc,
    }

    LANGUAGE = {
      japanese: 0x0,
      english: 0x1,
      german: 0x2,
      spanish: 0x3,
      italian: 0x4,
      french: 0x5,
      portuguese: 0x6,
      dutch: 0x7,
      polish: 0x8,
      norwegian: 0x9,
      russian: 0xa,
      simplified_chinese: 0xb,
      traditional_chinese: 0xc,
    }

    MENU_POSITION = {
      top_left: 0x0,
      top_right: 0x1,
      center: 0x2,
      bottom_left: 0x3,
      bottom_right: 0x4,
    }

    BACKGROUND_COLOR = {
      blue: 0x0,
      black: 0x1,
    }

    ANAMORPHIC = {
      off: 0x0,
      a: 0x1,
      b: 0x2,
      c: 0x3,
    }

    INSTALLATION_STYLE = {
      front: 0x0,
      ceiling_mount_front: 0x1,
      rear: 0x2,
      ceiling_mount_rear: 0x3,
    }

    ASPECT = {
      zoom: 0x2,
      auto: 0x3,
      native: 0x4,
    }

    MODE_3D = {
      "2d": 0x0,
      auto: 0x1,
      sxs: 0x3,
      tab: 0x4,    
    }

    INPUT_LEVEL = {
      standard: 0x0,
      enhanced: 0x1,
      super_white: 0x2,
      auto: 0x3,
    }

    GRAPHIC_MODE = {
      standard: 0x0,
      high_res: 0x1,
    }

    LAMP_POWER = {
      normal: 0x0,
      high: 0x1,
    }

    MOTION_ENHANCE = {
      off: 0x0,
      low: 0x1,
      high: 0x2,
    }

    CLEAR_MOTION_DRIVE = {
      off: 0x0,
      low: 0x3,
      high: 0x4,
      inverse_telecine: 0x5,
    }

    GAMMA_CORRECTION = {
      cinema1: 0x01,
      cinema2: 0x02,
      import: 0x04,
      "1.8": 0x05,
      "1.9": 0x06,
      "2.0": 0x07,
      "2.1": 0x08,
      "2.2": 0x09,
      "2.3": 0x0a,
      "2.4": 0x0b,
      "2.5": 0x0c,
      "2.6": 0x0d,
      film1: 0x0e,
      film2: 0x0f,
      hdr_hlg: 0x14,
      hdr_pq: 0x15,
    }

    COLOR_TEMPERATURE_CORRECTION = {
      "5500K": 0x00,
      "6500K": 0x02,
      "7500K": 0x04,
      "9300K": 0x08,
      high_bright: 0x09,
      xenon1: 0x0d,
      xenon2: 0x0e
    }

    COLOR_PROFILE = {
      off: 0x00,
      film1: 0x02,
      "bt.709": 0x03,
      cinema: 0x04,
      anime: 0x06,
      video: 0x08,
      hdr: 0x0a,
      "bt.2020": 0x0b,
      thx: 0x0d,
      custom1: 0x0e,
      custom2: 0x0f,
      custom3: 0x10,
      custom4: 0x11,
      custom5: 0x12,
      custom6: 0x22,
      dci: 0x21
    }

    INTELLIGENT_LENS_APERTURE = {
      off: 0x0,
      auto1: 0x1,
      auto2: 0x2,
    }

    PICTURE_MODE = {
      film: 0x00,
      cinema: 0x01,
      natural: 0x03,
      hdr10: 0x04,
      thx: 0x06,
      user1: 0x0c,
      user2: 0x0d,
      user3: 0x0e,
      user4: 0x0f,
      user5: 0x10,
      user6: 0x11,
      hlg: 0x14,
    }

    RANGES = {
      parallax_3d: -15..15,
      off_timer: 0..4,
      keystone: -16..16,
    }
  end
end
