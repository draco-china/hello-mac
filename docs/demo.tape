# Load the real environment prepared by scripts/prepare-demo.sh.
Output docs/demo.gif
Require zsh
Set Shell "bash"
Set FontFamily "SauceCodePro Nerd Font Mono"
Set FontSize 18
Set Width 1280
Set Height 720
Set Padding 24
Set Theme "Dracula"
Set TypingSpeed 75ms
Set Framerate 15

Hide
Type "export ZDOTDIR=\"$HELLO_MAC_DEMO_DIR/zsh\"; exec zsh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

Type "ls"
Enter
Sleep 2s
Type "cd config/zsh"
Enter
Sleep 2s
Type "ls"
Enter
Sleep 2s
Type "cd ../.."
Enter
Sleep 2s

Hide
Type "clear"
Enter
Sleep 500ms
Show
Type "./setup.sh --help"
Enter
Sleep 4s

# Retype a command from the recording's own history to show autosuggestions.
Type "./set"
Sleep 3s
Right
Sleep 1s
Ctrl+C
Sleep 2s
