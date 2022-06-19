#!/usr/bin/env bash

# shellcheck disable=SC2010

version='2.0.0'

# Source helpers script
. "$(dirname "$0")/helpers.sh"


function get_bing_image {

  # Set default vaules if none specified as arguments
  output_path=${output_path:=$HOME/Pictures/wallpapers}
  screen_dimensions=${screen_dimensions:=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')}

  # Get Bing image of the day xml file and extract the url and filename
  wget "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US" --output-document=/tmp/bingimage.xml > /dev/null 2>&1
  url_base=$(xmllint --xpath "string(//images/image/urlBase)" /tmp/bingimage.xml)
  name=$(xmllint --xpath "string(//images/image/startdate)" /tmp/bingimage.xml)

  # Download the image, or if it already exists, just use it
  if [[ -f "$output_path/$name.jpg" ]]; then
    log 'Todays Bing image of the day already exists. Setting image from local cache'
  else
    wget "https://bing.com${url_base}_$screen_dimensions.jpg" --output-document="$output_path/$name.jpg" > /dev/null 2>&1
  fi

  # Set the image as the wallpaper
  gsettings set org.gnome.desktop.background picture-uri "file://$output_path/$name.jpg"

  exit 0
}


function print_help {

    printf "Random Backgound Image v$version\n"
    printf "  Usage:\n"
    printf "  rbk [ARGUMENTS]\n\n"
    printf "  Options:\n"
    printf "   -b     Download Bing's image of the day and apply as background\n"
    printf "   -d     Set specific image dimensions to download (e.g. 1920x1080)\n"
    printf "   -h     Display help\n"
    printf "   -p     Specify path to save images to. Default is: $HOME/Pictures/wallpapers\n"
    printf "   -v     Display version\n"

    exit 0
}


function print_version {
  printf "$version\n"
  exit 0
}

# Parse command line arguments
while getopts 'bd:hp:v' opt; do
  case $opt in
    b) get_bing_image ;;
    d) screen_dimensions="$OPTARG" ;;
    h) print_help ;;
    p) output_path="$OPTARG" ;;
    v) print_version ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Get images in wallpapers directory, and pick one at random
backgrounds=($output_path/*)
backgroundcount=$(ls "$output_path" -l | grep -c ^l)
backgroundcount="$((backgroundcount - 2))"
random_number=$(shuf -i 0-$backgroundcount -n 1)

# Set random background
gsettings set org.gnome.desktop.background picture-uri "file://${backgrounds[$random_number]}"
