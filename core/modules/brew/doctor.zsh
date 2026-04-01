# brew module — doctor

if (( $+commands[brew] )); then
  ome_info "[✓] brew: $(brew --version 2>&1 | head -1)"
  return 0
else
  ome_warn "[!] brew: not found"
  return 1
fi
