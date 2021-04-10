#/bin/sh

curl -s https://api.github.com/repos/duukkis/arcade/releases/latest \
| grep "LinuxX11.zip" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

unzip -o LinuxX11.zip
