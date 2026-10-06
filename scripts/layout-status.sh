#!/usr/bin/env bash
set -euo pipefail

layout="$(swaymsg -t get_tree -r | jq -r '
    def focused_layout($parent_layout):
        . as $node
        | (if $node.layout != null and $node.layout != "none" then $node.layout else $parent_layout end) as $current_layout
        | ([($node.nodes[]?, $node.floating_nodes[]?) | focused_layout($current_layout)] | map(select(. != null)) | .[0]) as $child_layout
        | if $child_layout != null then $child_layout
          elif $node.focused then $current_layout
          else null
          end;
    focused_layout("splith") // "splith"
')"

case "$layout" in
    splith)   printf 'Horizontal Split\n' ;;
    splitv)   printf 'Vertical Split\n' ;;
    tabbed)   printf 'Tabbed\n' ;;
    stacking) printf 'Stacking\n' ;;
    *)        printf '%s\n' "$layout" ;;
esac
