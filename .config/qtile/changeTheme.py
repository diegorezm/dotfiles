import os, json, click
from colors import ayu_dark, macchiato,gruvbox

filepath = os.path.join("colors", "colorscheme.json")

def colorScheme(colorscheme):
        if colorscheme == 1:
            return macchiato.macchiato
        elif colorscheme == 2:
            return  ayu_dark.ayu_dark
        elif colorscheme == 3:
            return gruvbox.gruvbox


@click.command()
@click.option("--theme", help="1.Macchiato\n2.Ayu dark \n3.Gruvbox" , type=int)
def setColorscheme(theme):
    color = colorScheme(theme)
    with open(filepath,"w") as file:
        json.dump(color, file,indent=4)
    return color

if __name__ == "__main__":
    setColorscheme()
