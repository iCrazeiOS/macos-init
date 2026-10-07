# macos-init

One script to apply macOS settings for Dock, Finder, and screenshots.

These are just some random settings that I like to set on each machine.

## Features

### Dock
- Position on the left
- Autohide with instant show (no delay)
- Fast open/close animation
- No recent apps
- Scroll up on icon to see all windows / open stack

### Finder
- Show all file extensions
- Show hidden files
- Show path bar
- No toolbar title hover delay
- Show folder icon in title bar
- Folders on top when sorting by name
- Default search scope: current folder
- Save new documents to home, not iCloud
- No warning when changing file extensions

### Screenshots
- No window shadows
- No thumbnail preview after capture

## Key mapping

### Dock

| Domain | Key | Display name |
| --- | --- | --- |
| com.apple.dock | orientation | Position Dock on the left |
| com.apple.dock | autohide | Autohide the Dock |
| com.apple.dock | autohide-time-modifier | Fast Dock open/close animation |
| com.apple.dock | autohide-delay | No Dock autohide delay |
| com.apple.dock | show-recents | No recent apps in the Dock |
| com.apple.dock | scroll-to-open | Scroll up on Dock icon to show all windows / open stack |

### Finder

| Domain | Key | Display name |
| --- | --- | --- |
| NSGlobalDomain | AppleShowAllExtensions | Show all file extensions |
| com.apple.finder | AppleShowAllFiles | Show hidden files |
| com.apple.finder | ShowPathbar | Show path bar |
| NSGlobalDomain | NSToolbarTitleViewRolloverDelay | No toolbar title hover delay |
| com.apple.universalaccess | showWindowTitlebarIcons | Show folder icon in title bar |
| com.apple.finder | _FXSortFoldersFirst | Keep folders on top when sorting by name |
| com.apple.finder | FXDefaultSearchScope | Default search scope: current folder |
| NSGlobalDomain | NSDocumentSaveNewDocumentsToCloud | Save new documents to home, not iCloud |
| com.apple.finder | FXEnableExtensionChangeWarning | No warning when changing a file extension |

### Screenshots

| Domain | Key | Display name |
| --- | --- | --- |
| com.apple.screencapture | disable-shadow | No window shadow in screenshots |
| com.apple.screencapture | show-thumbnail | No thumbnail preview after capture |
