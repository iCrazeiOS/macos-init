#!/bin/bash

set_dock() {
    # Set the Dock position
    defaults write com.apple.dock "orientation" -string "left"

    # Autohide the Dock when the mouse is out
    defaults write com.apple.dock "autohide" -bool "true"

    # Change the Dock opening and closing animation times
    defaults write com.apple.dock "autohide-time-modifier" -float "0.1"

    # Remove the autohide delay, the Dock appears instantly
    defaults write com.apple.dock "autohide-delay" -float "0"

    # Do not display recent apps in the Dock
    defaults write com.apple.dock "show-recents" -bool "false"

    # Scroll up on a Dock icon to show all Space's opened windows for an app, or open stack
    defaults write com.apple.dock "scroll-to-open" -bool "true"
}

set_finder() {
    # Show all file extensions in the Finder
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

    # Show hidden files in the Finder
    defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

    # Show path bar in the bottom of the Finder windows
    defaults write com.apple.finder "ShowPathbar" -bool "true"

    # Remove the delay when hovering the toolbar title
    defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"

    # Show folder icon before title in the title bar
    defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true"

    # Keep folders on top when sorting by name
    defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

    # Set the default search scope to the current folder
    defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

    # Open the home directory instead of iCloud when saving a new document
    defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"

    # Do not display a warning when changing a file extension
    defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
}

set_screenshots() {
    # Remove the default shadow from screenshots
    defaults write com.apple.screencapture "disable-shadow" -bool "true"

    # Do not display the thumbnail after taking a screenshot
    defaults write com.apple.screencapture "show-thumbnail" -bool "false"
}

echo "Which category?"
echo "  1) Dock"
echo "  2) Finder"
echo "  3) Screenshots"
echo "  4) All"
read -r -p "Choice (1/2/3/4): " choice

kill_dock=false
kill_finder=false

case "$choice" in
    1)
        set_dock
        kill_dock=true
        ;;
    2)
        set_finder
        kill_finder=true
        ;;
    3)
        set_screenshots
        ;;
    4)
        set_dock
        set_finder
        set_screenshots
        kill_dock=true
        kill_finder=true
        ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

if $kill_dock && $kill_finder; then
    killall Dock Finder
elif $kill_dock; then
    killall Dock
elif $kill_finder; then
    killall Finder
fi

echo "Done"
