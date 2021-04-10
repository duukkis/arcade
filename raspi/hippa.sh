#/bin/sh

if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | \
sed 's/\// /g') | cut -f1) ]; then
  echo up to date
else
  echo not up to date
  rm ./LinuxX11.zip
  rm -fr ./data_HagatonHippa
  rm -fr ./hagatonhippa-linux.pck

  git pull
  curl -s https://api.github.com/repos/duukkis/arcade/releases/latest \
  | grep "LinuxX11.zip" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -qi -

  unzip -o LinuxX11.zip
  ps -ef | grep 'godot_3.2.3_rpi4_export-template' | grep -v grep | awk '{print $2}' | xargs kill
  cd /home/pi/godot
  ./godot_3.2.3_rpi4_export-template.bin --main-pack "../arcade/raspi/hagatonhippa-linux.pck"
fi

