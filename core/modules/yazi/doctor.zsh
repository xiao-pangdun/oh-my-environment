# yazi doctor
if ! (( $+commands[yazi] )); then
  ome_warn "yazi not found — file manager unavailable"
  ome_info "  fix: brew install yazi"
  return 1
fi

ome_info "yazi: $(command yazi --version 2>&1 | head -1)"

# Optional dependencies
local dep desc fix
local -A deps=(
  [ffmpeg]="video thumbnails"
  [7z]="archive preview"
  [jq]="JSON preview"
  [pdftoppm]="PDF preview (poppler)"
  [fd]="file searching"
  [rg]="content searching"
  [fzf]="quick navigation"
  [zoxide]="directory history"
  [resvg]="SVG preview"
  [magick]="font, HEIC, and JPEG XL preview (ImageMagick)"
)
local -A fixes=(
  [ffmpeg]="brew install ffmpeg-full"
  [7z]="brew install sevenzip"
  [jq]="brew install jq"
  [pdftoppm]="brew install poppler"
  [fd]="brew install fd"
  [rg]="brew install ripgrep"
  [fzf]="brew install fzf"
  [zoxide]="brew install zoxide"
  [resvg]="brew install resvg"
  [magick]="brew install imagemagick-full"
)

for dep desc in "${(@kv)deps}"; do
  if ! (( $+commands[$dep] )); then
    ome_warn "yazi: $dep not found — $desc unavailable"
    ome_info "  fix: ${fixes[$dep]}"
  fi
done

ome_info "yazi: if ffmpeg or imagemagick is not working, try:"
ome_info "  brew link ffmpeg-full imagemagick-full -f --overwrite"
