//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", "~/.local/bin/scripts_bar/mpd.sh",						0,		9},
	/* {"", "~/.local/bin/scripts_bar/beef.sh",						30,		9}, */
	{"", "~/.local/bin/scripts_bar/sound.sh",						0,		10},
	{"", "~/.local/bin/scripts_bar/memory.sh",						20,		11},
	{"", "~/.local/bin/scripts_bar/therm.sh",						20,		12},
	/* {"", "~/.local/bin/scripts_bar/wttr.sh",						100,		13}, */
	{"", "~/.local/bin/scripts_bar/updates_bar.sh",						300,		14},
	{"", "~/.local/bin/scripts_bar/hr.sh",						20,		15},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim = '|';
