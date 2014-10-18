get_color() {
  cat $1 | grep "$2[ ]*:" | egrep -o "#[a-zA-Z0-9]*" | sed 's/#//'
}

echo "FOREGROUND=\"#FF$(get_color $1 "foreground")\""
echo "BACKGROUND=\"#FF$(get_color $1 "background")\""

echo -e

echo "BLACK=\"#FF$(get_color $1 "color8")\""
echo "RED=\"#FF$(get_color $1 "color9")\""
echo "GREEN=\"#FF$(get_color $1 "color10")\""
echo "YELLOW=\"#FF$(get_color $1 "color11")\""
echo "BLUE=\"#FF$(get_color $1 "color12")\""
echo "MAGENTA=\"#FF$(get_color $1 "color13")\""
echo "CYAN=\"#FF$(get_color $1 "color14")\""
echo "WHITE=\"#FF$(get_color $1 "color15")\""

echo -e

echo "BOLD_BLACK=\"#FF$(get_color $1 "color0")\""
echo "BOLD_RED=\"#FF$(get_color $1 "color1")\""
echo "BOLD_GREEN=\"#FF$(get_color $1 "color2")\""
echo "BOLD_YELLOW=\"#FF$(get_color $1 "color3")\""
echo "BOLD_BLUE=\"#FF$(get_color $1 "color4")\""
echo "BOLD_MAGENTA=\"#FF$(get_color $1 "color5")\""
echo "BOLD_CYAN=\"#FF$(get_color $1 "color6")\""
echo "BOLD_WHITE=\"#FF$(get_color $1 "color7")\""
