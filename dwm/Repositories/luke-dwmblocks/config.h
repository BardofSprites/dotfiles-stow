//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
    /*Icon*/	/*Command*/					/*Update Interval*/	/*Update Signal*/
    {"", "~/.local/bin/scripts/status/memory",					10,		1},
    {"", "~/.local/bin/scripts/status/internet",				10,		6},
    {"", "~/.local/bin/scripts/status/weather",				10,		2},
    {"", "~/.local/bin/scripts/status/volume-pulseaudio",		1,			3},
    {"🎵 ", "~/.local/bin/scripts/status/mediaplayer",		5,			10},
    /* {"🔆: ", "~/.local/bin/scripts/status/brightness.sh",			0,		1}, */
    {"", "~/.local/bin/scripts/status/battery.sh",				5,		7},
    {"", "date '+%Y-%m-%d (%A)'",						1,		4},
    {"", "date '+%R:%S'",							1,		5},

};

//Sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char *delim = " | ";

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
