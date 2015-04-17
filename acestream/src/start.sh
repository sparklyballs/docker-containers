#!/bin/bash



cat > /home/tv/aceproxy-master/plugins/config/torrenttv.py << EOF
url = '$TTV_URL'
updateevery = 0
EOF




sed -i 's/vlcuse = False/vlcuse = True/' /home/tv/aceproxy-master/aceconfig.py
sed -i 's/videoobey = True/videoobey = False/' /home/tv/aceproxy-master/aceconfig.py
sed -i 's/videopausedelay = .*/videopausedelay = 0/' /home/tv/aceproxy-master/aceconfig.py
sed -i 's/videodelay = .*/videodelay = 0/' /home/tv/aceproxy-master/aceconfig.py
sed -i 's/videodestroydelay = .*/videodestroydelay = 30/' /home/tv/aceproxy-master/aceconfig.py

exec /usr/bin/supervisord
