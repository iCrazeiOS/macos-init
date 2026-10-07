#!/bin/bash

# --- Options ----------------------------------------------------------------

dock_desc=(
    "Position Dock on the left"
    "Autohide the Dock"
    "Fast Dock open/close animation"
    "No Dock autohide delay"
    "No recent apps in the Dock"
    "Scroll up on Dock icon to show all windows / open stack"
)
dock_cmd=(
    'defaults write com.apple.dock "orientation" -string "left"'
    'defaults write com.apple.dock "autohide" -bool "true"'
    'defaults write com.apple.dock "autohide-time-modifier" -float "0.1"'
    'defaults write com.apple.dock "autohide-delay" -float "0"'
    'defaults write com.apple.dock "show-recents" -bool "false"'
    'defaults write com.apple.dock "scroll-to-open" -bool "true"'
)

finder_desc=(
    "Show all file extensions"
    "Show hidden files"
    "Show path bar"
    "No toolbar title hover delay"
    "Show folder icon in title bar"
    "Keep folders on top when sorting by name"
    "Default search scope: current folder"
    "Save new documents to home, not iCloud"
    "No warning when changing a file extension"
)
finder_cmd=(
    'defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"'
    'defaults write com.apple.finder "AppleShowAllFiles" -bool "true"'
    'defaults write com.apple.finder "ShowPathbar" -bool "true"'
    'defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"'
    'defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true"'
    'defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"'
    'defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"'
    'defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"'
    'defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"'
)

screenshots_desc=(
    "No window shadow in screenshots"
    "No thumbnail preview after capture"
)
screenshots_cmd=(
    'defaults write com.apple.screencapture "disable-shadow" -bool "true"'
    'defaults write com.apple.screencapture "show-thumbnail" -bool "false"'
)

# --- Preset prompt ------------------------------------------------------------

echo "Which preset would you like to apply?"
echo "  1) Dock"
echo "  2) Finder"
echo "  3) Screenshots"
echo "  4) All"
read -r -p "Choice (1/2/3/4): " choice

# Build the flat option list (category, description, command) for the preset
opt_cat=(); opt_desc=(); opt_cmd=()

add_category() {
    local cat="$1"
    local desc_name="$2_desc[@]"
    local cmd_name="$2_cmd[@]"
    local descs=("${!desc_name}")
    local cmds=("${!cmd_name}")
    local i
    for ((i = 0; i < ${#descs[@]}; i++)); do
        opt_cat+=("$cat")
        opt_desc+=("${descs[i]}")
        opt_cmd+=("${cmds[i]}")
    done
}

case "$choice" in
    1) add_category "Dock" dock ;;
    2) add_category "Finder" finder ;;
    3) add_category "Screenshots" screenshots ;;
    4)
        add_category "Dock" dock
        add_category "Finder" finder
        add_category "Screenshots" screenshots
        ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# --- Interactive multi-select -------------------------------------------------

cursor=0
selected=()
for ((i = 0; i < ${#opt_desc[@]}; i++)); do
    selected[i]=1
done

draw_menu() {
    menu_lines=0
    echo ""
    ((menu_lines++))
    echo "Use UP/DOWN to move, SPACE to toggle, ENTER to confirm"
    ((menu_lines++))
    echo ""
    ((menu_lines++))
    local last_cat="" mark pointer i
    for ((i = 0; i < ${#opt_desc[@]}; i++)); do
        if [[ ${opt_cat[i]} != "$last_cat" ]]; then
            [[ -n $last_cat ]] && { echo ""; ((menu_lines++)); }
            echo "${opt_cat[i]}:"
            ((menu_lines++))
            last_cat=${opt_cat[i]}
        fi
        mark="[ ]"
        [[ ${selected[i]} -eq 1 ]] && mark="[*]"
        pointer="  "
        [[ $i -eq $cursor ]] && pointer="> "
        echo "${pointer}${mark} ${opt_desc[i]}"
        ((menu_lines++))
    done
}

tput civis
draw_menu
while true; do
    IFS= read -rsn1 key
    case "$key" in
        $'\x1b')
            read -rsn2 -t 1 key
            case "$key" in
                '[A') ((cursor > 0)) && ((cursor--)) ;;
                '[B') ((cursor < ${#opt_desc[@]} - 1)) && ((cursor++)) ;;
            esac
            ;;
        ' ')
            if [[ ${selected[cursor]} -eq 1 ]]; then
                selected[cursor]=0
            else
                selected[cursor]=1
            fi
            ;;
        '')
            break
            ;;
        *) continue ;;
    esac
    tput cuu "$menu_lines"
    draw_menu
done
tput cnorm
echo ""

# --- Apply --------------------------------------------------------------------

kill_dock=false
kill_finder=false
applied=0

for ((i = 0; i < ${#opt_cmd[@]}; i++)); do
    [[ ${selected[i]} -eq 1 ]] || continue
    eval "${opt_cmd[i]}"
    ((applied++))
    case "${opt_cat[i]}" in
        Dock) kill_dock=true ;;
        Finder) kill_finder=true ;;
    esac
done

restart_app() {
    echo "Restarting $1..."
    killall "$1"
}

$kill_dock && restart_app Dock
$kill_finder && restart_app Finder

echo "Applied $applied preferences"
