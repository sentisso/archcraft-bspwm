# ------------------------------------------------------------------------------
# Copyright (C) 2020-2024 Aditya Shakya <adi1090x@gmail.com>
#
# Default Theme
# ------------------------------------------------------------------------------

# Colors
background='#0d1117'
foreground='#B9BDC4'
color_black='#3B4252' # color0
color_red='#E06B74' # color1
color_green='#98C379' # color2
color_yellow='#E5C07A' # color3
color_blue='#13CADA' # color4
color_magenta='#C778DD' # color5
color_cyan='#55B6C2' # color6
color_white='#B9BDC4' # color7
altcolor_black='#4C566A' # color8
altcolor_red='#EA757E' # color9
altcolor_green='#A2CD83' # color10
altcolor_yellow='#EFCA84' # color11
altcolor_blue='#13CADA' # color12
altcolor_magenta='#D282E7' # color13
altcolor_cyan='#5FC0CC' # color14
altcolor_white='#B5BCC9' # color15

accent='#13CADA'
light_value='0.00'
dark_value='0.30'

# Wallpaper
wdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
wallpaper="$wdir/wallpaper"

# Polybar
polybar_font='FiraCode Nerd Font:size=9;3'

# Rofi
rofi_font='Iosevka 10'
rofi_icon='Arc-Circle'

# Terminal
terminal_font_name='JetBrainsMono Nerd Font'
terminal_font_size='10'

# Geany
geany_colors='arc.conf'
geany_font='JetBrainsMono Nerd Font 10'

# Appearance
gtk_font='Noto Sans 9'
gtk_theme='Arc-Dark'
icon_theme='Arc-Circle'
cursor_theme='Qogirr'

# Dunst
dunst_width='300'
dunst_height='80'
dunst_offset='10x42'
dunst_origin='top-right'
dunst_font='Iosevka Custom 9'
dunst_border='1'
dunst_separator='1'

# Picom
picom_backend='glx'
picom_corner='0'
picom_shadow_r='20'
picom_shadow_o='0.60'
picom_shadow_x='-20'
picom_shadow_y='-20'
picom_blur_method='none'
picom_blur_strength='0'
picom_blur='false'

# Bspwm
bspwm_fbc="$accent"
bspwm_nbc="$background"
bspwm_abc="$color_magenta"
bspwm_pfc="$color_green"
bspwm_border='1'
bspwm_gap='10'
bspwm_sratio='0.50'
