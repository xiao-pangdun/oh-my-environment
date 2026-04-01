# claude module — doctor

if (( $+commands[claude] )); then
  ome_info "[✓] claude: $(claude --version 2>&1 | head -1)"
  return 0
else
  ome_warn "[!] claude: not found"
  return 1
fi
