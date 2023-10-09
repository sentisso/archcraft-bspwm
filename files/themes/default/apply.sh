#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
##
## Script To Apply Themes

## Theme ------------------------------------
BDIR="$HOME/.config/bspwm"
TDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
THEME="${TDIR##*/}"

source "$BDIR"/themes/"$THEME"/theme.bash
altbackground="`pastel color $background | pastel lighten $light_value | pastel format hex`"
altforeground="`pastel color $foreground | pastel darken $dark_value | pastel format hex`"

## Directories ------------------------------
PATH_CONF="$HOME/.config"
PATH_GEANY="$PATH_CONF/geany"
PATH_BSPWM="$PATH_CONF/bspwm"
PATH_TERM="$PATH_BSPWM/alacritty"
PATH_PBAR="$PATH_BSPWM/themes/$THEME/polybar"
PATH_ROFI="$PATH_BSPWM/themes/$THEME/rofi"
PATH_XFCE="$PATH_CONF/xfce4/terminal"
PATH_CONKY="$PATH_BSPWM/themes/$THEME/conky"

## Wallpaper ---------------------------------
apply_wallpaper() {
	feh --bg-center --image-bg black "$wallpaper"
}

## Polybar -----------------------------------
apply_polybar() {
	# modify polybar launch script
	sed -i -e "s/STYLE=.*/STYLE=\"$THEME\"/g" ${PATH_BSPWM}/themes/polybar.sh

	# apply default theme fonts
	sed -i -e "s/font-0 = .*/font-0 = \"$polybar_font\"/g" ${PATH_PBAR}/config.ini

	# rewrite colors file
	cat > ${PATH_PBAR}/colors.ini <<- EOF
		[color]
		
		BACKGROUND = #000000
		FOREGROUND = ${foreground}
		ALTBACKGROUND = ${altbackground}
		ALTFOREGROUND = ${altforeground}
		ACCENT = ${accent}
		
		BLACK = ${color_black}
		RED = ${color_red}
		GREEN = ${color_green}
		YELLOW = ${color_yellow}
		BLUE = ${color_blue}
		MAGENTA = ${color_magenta}
		CYAN = ${color_cyan}
		WHITE = ${color_white}
		ALTBLACK = ${altcolor_black}
		ALTRED = ${altcolor_red}
		ALTGREEN = ${altcolor_green}
		ALTYELLOW = ${altcolor_yellow}
		ALTBLUE = ${altcolor_blue}
		ALTMAGENTA = ${altcolor_magenta}
		ALTCYAN = ${altcolor_cyan}
		ALTWHITE = ${altcolor_white}
	EOF
}

# Rofi --------------------------------------
apply_rofi() {
	# modify rofi scripts
	sed -i -e "s/STYLE=.*/STYLE=\"$THEME\"/g" \
		${PATH_BSPWM}/scripts/rofi_askpass \
		${PATH_BSPWM}/scripts/rofi_asroot \
		${PATH_BSPWM}/scripts/rofi_bluetooth \
		${PATH_BSPWM}/scripts/rofi_launcher \
		${PATH_BSPWM}/scripts/rofi_music \
		${PATH_BSPWM}/scripts/rofi_powermenu \
		${PATH_BSPWM}/scripts/rofi_runner \
		${PATH_BSPWM}/scripts/rofi_screenshot \
		${PATH_BSPWM}/scripts/rofi_themes \
		${PATH_BSPWM}/scripts/rofi_windows
	
	# apply default theme fonts
	sed -i -e "s/font:.*/font: \"$rofi_font\";/g" ${PATH_ROFI}/shared/fonts.rasi

	# rewrite colors file
	cat > ${PATH_ROFI}/shared/colors.rasi <<- EOF
		* {
		    background:     ${background};
		    background-alt: ${altbackground};
		    foreground:     ${foreground};
		    selected:       ${accent};
		    active:         ${color_green};
		    urgent:         ${color_red};
		}
	EOF

	# modify icon theme
	if [[ -f "$PATH_CONF"/rofi/config.rasi ]]; then
		sed -i -e "s/icon-theme:.*/icon-theme: \"$rofi_icon\";/g" ${PATH_CONF}/rofi/config.rasi
	fi
}

# Network Menu ------------------------------
apply_netmenu() {
	if [[ -f "$PATH_CONF"/networkmanager-dmenu/nmd.ini ]]; then
		sed -i -e "s#dmenu_command = .*#dmenu_command = rofi -dmenu -theme $PATH_ROFI/networkmenu.rasi#g" ${PATH_CONF}/networkmanager-dmenu/nmd.ini
	fi
}

# Terminal ----------------------------------
apply_terminal() {
	# alacritty : fonts
	sed -i ${PATH_TERM}/fonts.yml \
		-e "s/family: .*/family: \"$terminal_font_name\"/g" \
		-e "s/size: .*/size: $terminal_font_size/g"

	# alacritty : colors
	cat > ${PATH_TERM}/colors.yml <<- _EOF_
		## Colors configuration
		colors:
		  # Default colors
		  primary:
		    background: '${background}'
		    foreground: '${foreground}'

		  # Normal colors
		  normal:
		    black:   '${color_black}'
		    red:     '${color_red}'
		    green:   '${color_green}'
		    yellow:  '${color_yellow}'
		    blue:    '${color_blue}'
		    magenta: '${color_magenta}'
		    cyan:    '${color_cyan}'
		    white:   '${color_white}'

		  # Bright colors
		  bright:
		    black:   '${altcolor_black}'
		    red:     '${altcolor_red}'
		    green:   '${altcolor_green}'
		    yellow:  '${altcolor_yellow}'
		    blue:    '${altcolor_blue}'
		    magenta: '${altcolor_magenta}'
		    cyan:    '${altcolor_cyan}'
		    white:   '${altcolor_white}'
	_EOF_

	# xfce terminal : fonts & colors
	sed -i ${PATH_XFCE}/terminalrc \
		-e "s/FontName=.*/FontName=$terminal_font_name $terminal_font_size/g" \
		-e "s/ColorBackground=.*/ColorBackground=${background}/g" \
		-e "s/ColorForeground=.*/ColorForeground=${foreground}/g" \
		-e "s/ColorCursor=.*/ColorCursor=${foreground}/g" \
		-e "s/ColorPalette=.*/ColorPalette=${color_black};${color_red};${color_green};${color_yellow};${color_blue};${color_magenta};${color_cyan};${color_white};${altcolor_black};${altcolor_red};${altcolor_green};${altcolor_yellow};${altcolor_blue};${altcolor_magenta};${altcolor_cyan};${altcolor_white}/g" \
		-e "s/ColorUseTheme=.*/ColorUseTheme=FALSE/g" \
		-e "s/BackgroundMode=.*/BackgroundMode=TERMINAL_BACKGROUND_TRANSPARENT/g" \
		-e "s/BackgroundDarkness=.*/BackgroundDarkness=0,950000/g"
}

# Geany -------------------------------------
apply_geany() {
	sed -i ${PATH_GEANY}/geany.conf \
		-e "s/color_scheme=.*/color_scheme=$geany_colors/g" \
		-e "s/editor_font=.*/editor_font=$geany_font/g"
}

# Appearance --------------------------------
apply_appearance() {
	XFILE="$PATH_BSPWM/xsettingsd"
	GTK2FILE="$HOME/.gtkrc-2.0"
	GTK3FILE="$PATH_CONF/gtk-3.0/settings.ini"

	# apply gtk theme, icons, cursor & fonts
	if [[ `pidof xsettingsd` ]]; then
		sed -i -e "s|Net/ThemeName .*|Net/ThemeName \"$gtk_theme\"|g" ${XFILE}
		sed -i -e "s|Net/IconThemeName .*|Net/IconThemeName \"$icon_theme\"|g" ${XFILE}
		sed -i -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$cursor_theme\"|g" ${XFILE}
	else
		sed -i -e "s/gtk-font-name=.*/gtk-font-name=\"$gtk_font\"/g" ${GTK2FILE}
		sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/g" ${GTK2FILE}
		sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$icon_theme\"/g" ${GTK2FILE}
		sed -i -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$cursor_theme\"/g" ${GTK2FILE}
		
		sed -i -e "s/gtk-font-name=.*/gtk-font-name=$gtk_font/g" ${GTK3FILE}
		sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/g" ${GTK3FILE}
		sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/g" ${GTK3FILE}
		sed -i -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor_theme/g" ${GTK3FILE}
	fi
	
	# inherit cursor theme
	if [[ -f "$HOME"/.icons/default/index.theme ]]; then
		sed -i -e "s/Inherits=.*/Inherits=$cursor_theme/g" "$HOME"/.icons/default/index.theme
	fi	
}

# Dunst -------------------------------------
apply_dunst() {
	# modify dunst config
	sed -i ${PATH_BSPWM}/dunstrc \
		-e "s/width = .*/width = $dunst_width/g" \
		-e "s/height = .*/height = $dunst_height/g" \
		-e "s/offset = .*/offset = $dunst_offset/g" \
		-e "s/origin = .*/origin = $dunst_origin/g" \
		-e "s/font = .*/font = $dunst_font/g" \
		-e "s/frame_width = .*/frame_width = $dunst_border/g" \
		-e "s/separator_height = .*/separator_height = $dunst_separator/g" \
		-e "s/line_height = .*/line_height = $dunst_separator/g"

	# modify colors
	sed -i '/urgency_low/Q' ${PATH_BSPWM}/dunstrc
	cat >> ${PATH_BSPWM}/dunstrc <<- _EOF_
		[urgency_low]
		timeout = 2
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${accent}"

		[urgency_normal]
		timeout = 5
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${accent}"

		[urgency_critical]
		timeout = 0
		background = "${background}"
		foreground = "${color_red}"
		frame_color = "${color_red}"
	_EOF_
}

# Compositor --------------------------------
apply_compositor() {
	picom_cfg="$PATH_BSPWM/picom.conf"

	# modify picom config
	sed -i "$picom_cfg" \
		-e "s/backend = .*/backend = \"$picom_backend\";/g" \
		-e "s/corner-radius = .*/corner-radius = $picom_corner;/g" \
		-e "s/shadow-radius = .*/shadow-radius = $picom_shadow_r;/g" \
		-e "s/shadow-opacity = .*/shadow-opacity = $picom_shadow_o;/g" \
		-e "s/shadow-offset-x = .*/shadow-offset-x = $picom_shadow_x;/g" \
		-e "s/shadow-offset-y = .*/shadow-offset-y = $picom_shadow_y;/g" \
		-e "s/method = .*/method = \"$picom_blur_method\";/g" \
		-e "s/strength = .*/strength = $picom_blur_strength;/g"
}

# BSPWM -------------------------------------
apply_bspwm() {
	# modify bspwmrc
	sed -i ${PATH_BSPWM}/bspwmrc \
		-e "s/BSPWM_FBC=.*/BSPWM_FBC='$bspwm_fbc'/g" \
		-e "s/BSPWM_NBC=.*/BSPWM_NBC='$bspwm_nbc'/g" \
		-e "s/BSPWM_ABC=.*/BSPWM_ABC='$bspwm_abc'/g" \
		-e "s/BSPWM_PFC=.*/BSPWM_PFC='$bspwm_pfc'/g" \
		-e "s/BSPWM_BORDER=.*/BSPWM_BORDER='$bspwm_border'/g" \
		-e "s/BSPWM_GAP=.*/BSPWM_GAP='$bspwm_gap'/g" \
		-e "s/BSPWM_SRATIO=.*/BSPWM_SRATIO='$bspwm_sratio'/g"
	
	# reload bspwm
	bspc wm -r
}

# Create Theme File -------------------------
create_file() {
	theme_file="$PATH_BSPWM/themes/.current"
	if [[ ! -f "$theme_file" ]]; then
		touch ${theme_file}
	fi
	echo "$THEME" > ${theme_file}
}

# Notify User -------------------------------
notify_user() {
	dunstify -u normal -h string:x-dunst-stack-tag:applytheme -i /usr/share/archcraft/icons/dunst/themes.png "Applying Style : $THEME"
}

# Conky -------------------------------------
apply_conky() {
	cp -r "${PATH_CONKY}" "${PATH_CONF}"
	pkill conky
	conky --daemonize
}

## Execute Script ---------------------------
notify_user
create_file
apply_wallpaper
apply_polybar
apply_rofi
apply_netmenu
apply_terminal
apply_geany
apply_appearance
apply_dunst
apply_compositor
apply_bspwm
apply_conky
