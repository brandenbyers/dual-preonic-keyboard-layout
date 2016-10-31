# Dual Preonic Keyboard Layout

## Install SKIM for pdf watching while editing

http://skim-app.sourceforge.net/
or
`brew cask install skim`

## Watch dot file with watch-then-cli

`npm i -g watch-then-cli`

`watch keyboard-layout.dot then "dot -Tpdf keyboard-layout.dot -o keyboard-layout.pdf"`

## Convert keys

node convert-keys.sh --dot=/Users/branden/Projects/keyboard-layout/keyboard-layout.dot
