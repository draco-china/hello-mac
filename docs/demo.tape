# Record real CLI output only. Never run an actual installation in the demo.
Output docs/demo.gif
Require bash
Set Shell "bash"
Set FontFamily "JetBrains Mono"
Set FontSize 16
Set Width 1280
Set Height 720
Set Padding 24
Set Theme "Dracula"
Set TypingSpeed 45ms
Set Framerate 15

Hide
Type "export PS1='$ '; export HOME=/tmp/hello-mac-demo; unset ZSH ZSH_CUSTOM ZDOTDIR; clear"
Enter
Sleep 500ms
Show

Type "./setup.sh --help"
Enter
Sleep 5s

Hide
Type "clear"
Enter
Sleep 500ms
Show

Type "./setup.sh all --dry-run"
Enter
Sleep 8s
