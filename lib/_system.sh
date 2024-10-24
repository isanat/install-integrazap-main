#!/bin/bash
# system management

#######################################
# creates user
# Arguments:
#   None
#######################################
system_create_user() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos criar o usuário para a instancia...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo useradd -m -p "$(openssl passwd -crypt ${mysql_root_password})" -s /bin/bash -G sudo deploy
  sudo usermod -aG sudo deploy

  sleep 2
}

#######################################
# clones repositories using git
# Arguments:
#   None
#######################################
system_git_clone() {
  print_banner
  printf "${WHITE} 💻 Fazendo download do código Whaticket...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo su - deploy <<EOF
  git clone ${link_git} /home/deploy/${instancia_add}/
EOF

  sleep 2
}

#######################################
# updates system and installs dependencies
# Arguments:
#   None
#######################################
system_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o sistema...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo apt update -y
  sudo apt install -y libxshmfence-dev libgbm-dev wget unzip fontconfig locales \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 \
    libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation \
    libappindicator1 libnss3 lsb-release xdg-utils

  sleep 2
}

#######################################
# delete system
# Arguments:
#   None
#######################################
deletar_tudo() {
  print_banner
  printf "${WHITE} 💻 Deletando a Instância ${empresa_delete}...${GRAY_LIGHT}\n\n"

  sleep 2

  # Remove Redis container and Nginx configurations
  sudo docker container rm redis-${empresa_delete} --force
  sudo rm -rf /etc/nginx/sites-{enabled,available}/${empresa_delete}-frontend
  sudo rm -rf /etc/nginx/sites-{enabled,available}/${empresa_delete}-backend

  # Remove PostgreSQL user and database
  sudo -u postgres psql -c "DROP USER IF EXISTS ${empresa_delete};"
  sudo -u postgres psql -c "DROP DATABASE IF EXISTS ${empresa_delete};"

  # Remove files and stop processes
  sudo rm -rf /home/deploy/${empresa_delete}
  pm2 delete ${empresa_delete}-frontend ${empresa_delete}-backend
  pm2 save

  print_banner
  printf "${WHITE} 💻 Remoção da Instância ${empresa_delete} realizada com sucesso!${GRAY_LIGHT}\n\n"

  sleep 2
}

#######################################
# bloqueia system
# Arguments:
#   None
#######################################
configurar_bloqueio() {
  print_banner
  printf "${WHITE} 💻 Bloqueando o Whaticket...${GRAY_LIGHT}\n\n"

  sleep 2

  pm2 stop ${empresa_bloquear}-backend
  pm2 save

  print_banner
  printf "${WHITE} 💻 Bloqueio da Instância ${empresa_bloquear} realizado com sucesso!${GRAY_LIGHT}\n\n"

  sleep 2
}

#######################################
# desbloquear system
# Arguments:
#   None
#######################################
configurar_desbloqueio() {
  print_banner
  printf "${WHITE} 💻 Desbloqueando o Whaticket...${GRAY_LIGHT}\n\n"

  sleep 2

  pm2 start ${empresa_bloquear}-backend
  pm2 save

  print_banner
  printf "${WHITE} 💻 Desbloqueio da Instância ${empresa_bloquear} realizado com sucesso!${GRAY_LIGHT}\n\n"

  sleep 2
}

#######################################
# installs node.js
# Arguments:
#   None
#######################################
system_node_install() {
  print_banner
  printf "${WHITE} 💻 Instalando Node.js...${GRAY_LIGHT}\n\n"

  sleep 2

  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install -y nodejs
  npm install -g npm@latest
  sudo timedatectl set-timezone America/Sao_Paulo

  sleep 2
}

#######################################
# installs docker
# Arguments:
#   None
#######################################
system_docker_install() {
  print_banner
  printf "${WHITE} 💻 Instalando Docker...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt install -y docker-ce

  sleep 2
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_nginx_install() {
  print_banner
  printf "${WHITE} 💻 Instalando NGINX...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo apt install -y nginx
  sudo rm /etc/nginx/sites-enabled/default

  sleep 2
}

#######################################
# installs certbot
# Arguments:
#   None
#######################################
system_certbot_install() {
  print_banner
  printf "${WHITE} 💻 Instalando Certbot...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot

  sleep 2
}

#######################################
# Configurações de puppeteer
# Arguments:
#   None
#######################################
system_puppeteer_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do Puppeteer...${GRAY_LIGHT}\n\n"

  sleep 2

  sudo apt-get install -y libxshmfence-dev libgbm-dev wget unzip fontconfig locales gconf-service libasound2 \
    libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
    libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

  sleep 2
}
