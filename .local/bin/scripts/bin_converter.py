import subprocess
def dec2bin(n):
    bn = []
    n = int(n)
    while n > 0:
        bn.append(str(n % 2))
        n = n // 2

    return ''.join(bn[::-1])


def bin2dec(n):
    decimal = int(n,2)
    return decimal

file = open('/tmp/bin.txt','w')

choice=subprocess.run("echo 'dec2bin\nbin2dec' | dmenu -p 'Choose one:'",shell=True, stdout=subprocess.PIPE,universal_newlines=True, stderr=subprocess.PIPE).stdout.strip()
try:
    match choice:
        case 'dec2bin':
            n=subprocess.run("dmenu -p 'Decimal number:' ",shell=True, stdout=subprocess.PIPE,universal_newlines=True, stderr=subprocess.PIPE).stdout.strip()
            print(dec2bin(n),file = file)
            res=subprocess.Popen("cat /tmp/bin.txt | dmenu -p 'Copy:'| xclip -sel clip && dunstify 'Clipboard:' $(cat /tmp/bin.txt)",shell=True)
        case 'bin2dec':
            n=subprocess.run("dmenu -p 'Binary number:'",shell=True, stdout=subprocess.PIPE,universal_newlines=True, stderr=subprocess.PIPE).stdout.strip()
            print(bin2dec(n),file = file)
            res=subprocess.Popen("cat /tmp/bin.txt | dmenu  -p 'Copy:'| xclip -sel clip && dunstify 'Clipboard:' $(cat /tmp/bin.txt)",shell=True)
    file.close()
except:
    subprocess.Popen("dunstify 'ERRO!'",shell=True)
    file.close()
