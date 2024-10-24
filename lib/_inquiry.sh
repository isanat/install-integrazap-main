#!/bin/bash

#######################################
# Funções para coletar dados do usuário
#######################################

get_mysql_root_password() {
  print_banner
  printf "${WHITE} 💻 Insira senha para o usuário Deploy e Banco de Dados (Não utilizar caracteres especiais):${GRAY_LIGHT}\n"
  read -p "> " mysql_root_password

  # Validação: Não permitir caracteres especiais
  if [[ "$mysql_root_password" =~ [^a-zA-Z0-9] ]]; then
    printf "${RED}⚠️ A senha não pode conter caracteres especiais. Tente novamente.${NC}\n"
    get_mysql_root_password
  fi
}

get_link_git() {
  print_banner
  printf "${WHITE} 💻 Insira o link do GITHUB do Whaticket que deseja instalar:${GRAY_LIGHT}\n"
  read -p "> " link_git

  # Validação: Verificar se o link é válido
  if [[ ! "$link_git" =~ ^https://github.com ]]; then
    printf "${RED}⚠️ O link informado não parece ser válido. Tente novamente.${NC}\n"
    get_link_git
  fi
}

get_instancia_add() {
  print_banner
  printf "${WHITE} 💻 Informe um nome para a Instância/Empresa (Não utilizar espaços ou caracteres especiais, usar letras minúsculas):${GRAY_LIGHT}\n"
  read -p "> " instancia_add

  # Validação: Apenas letras minúsculas e números
  if [[ ! "$instancia_add" =~ ^[a-z0-9]+$ ]]; then
    printf "${RED}⚠️ Nome inválido. Tente novamente com apenas letras minúsculas e números.${NC}\n"
    get_instancia_add
  fi
}

get_max_whats() {
  print_banner
  printf "${WHITE} 💻 Informe a quantidade de conexões/Whats que a ${instancia_add} poderá cadastrar:${GRAY_LIGHT}\n"
  read -p "> " max_whats

  # Validação: Verificar se é um número
  if ! [[ "$max_whats" =~ ^[0-9]+$ ]]; then
    printf "${RED}⚠️ Insira um número válido.${NC}\n"
    get_max_whats
  fi
}

get_max_user() {
  print_banner
  printf "${WHITE} 💻 Informe a quantidade de Usuários/Atendentes que a ${instancia_add} poderá cadastrar:${GRAY_LIGHT}\n"
  read -p "> " max_user

  # Validação: Verificar se é um número
  if ! [[ "$max_user" =~ ^[0-9]+$ ]]; then
    printf "${RED}⚠️ Insira um número válido.${NC}\n"
    get_max_user
  fi
}

get_frontend_url() {
  print_banner
  printf "${WHITE} 💻 Digite o domínio do FRONTEND/PAINEL para a ${instancia_add}:${GRAY_LIGHT}\n"
  read -p "> " frontend_url

  # Validação: Verificar se o URL é válido
  if [[ ! "$frontend_url" =~ ^https?:// ]]; then
    printf "${RED}⚠️ O domínio do frontend deve começar com http:// ou https://. Tente novamente.${NC}\n"
    get_frontend_url
  fi
}

get_backend_url() {
  print_banner
  printf "${WHITE} 💻 Digite o domínio do BACKEND/API para a ${instancia_add}:${GRAY_LIGHT}\n"
  read -p "> " backend_url

  # Validação: Verificar se o URL é válido
  if [[ ! "$backend_url" =~ ^https?:// ]]; then
    printf "${RED}⚠️ O domínio do backend deve começar com http:// ou https://. Tente novamente.${NC}\n"
    get_backend_url
  fi
}

get_frontend_port() {
  print_banner
  printf "${WHITE} 💻 Digite a porta do FRONTEND para a ${instancia_add} (Ex: 3000 a 3999):${GRAY_LIGHT}\n"
  read -p "> " frontend_port

  # Validação: Verificar se é um número válido
  if ! [[ "$frontend_port" =~ ^[3][0-9]{3}$ ]]; then
    printf "${RED}⚠️ Insira uma porta válida entre 3000 e 3999.${NC}\n"
    get_frontend_port
  fi
}

get_backend_port() {
  print_banner
  printf "${WHITE} 💻 Digite a porta do BACKEND para a ${instancia_add} (Ex: 4000 a 4999):${GRAY_LIGHT}\n"
  read -p "> " backend_port

  # Validação: Verificar se é um número válido
  if ! [[ "$backend_port" =~ ^[4][0-9]{3}$ ]]; then
    printf "${RED}⚠️ Insira uma porta válida entre 4000 e 4999.${NC}\n"
    get_backend_port
  fi
}

get_redis_port() {
  print_banner
  printf "${WHITE} 💻 Digite a porta do REDIS/AGENDAMENTO MSG para a ${instancia_add} (Ex: 5000 a 5999):${GRAY_LIGHT}\n"
  read -p "> " redis_port

  # Validação: Verificar se é um número válido
  if ! [[ "$redis_port" =~ ^[5][0-9]{3}$ ]]; then
    printf "${RED}⚠️ Insira uma porta válida entre 5000 e 5999.${NC}\n"
    get_redis_port
  fi
}

#######################################
# Funções para operações de software
#######################################
software_update() {
  get_empresa_atualizar
  frontend_update
  backend_update
}

software_delete() {
  get_empresa_delete
  deletar_tudo
}

software_bloquear() {
  get_empresa_bloquear
  configurar_bloqueio
}

software_desbloquear() {
  get_empresa_desbloquear
  configurar_desbloqueio
}

software_dominio() {
  get_empresa_dominio
  get_alter_frontend_url
  get_alter_backend_url
  get_alter_frontend_port
  get_alter_backend_port
  configurar_dominio
}

#######################################
# Menu interativo de opções
#######################################
inquiry_options() {
  print_banner
  printf "${WHITE} 💻 Bem-vindo(a) ao Gerenciador PLW DESIGN, Selecione abaixo a próxima ação:${GRAY_LIGHT}\n"
  printf "\n"
  printf "   [0] Instalar Whaticket\n"
  printf "   [1] Atualizar Whaticket\n"
  printf "   [2] Deletar Whaticket\n"
  printf "   [3] Bloquear Whaticket\n"
  printf "   [4] Desbloquear Whaticket\n"
  printf "   [5] Alterar domínio do Whaticket\n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    0) get_urls ;;
    1) software_update ;;
    2) software_delete ;;
    3) software_bloquear ;;
    4) software_desbloquear ;;
    5) software_dominio ;;
    *) 
      printf "${RED}⚠️ Opção inválida. Tente novamente.${NC}\n"
      inquiry_options ;;
  esac
}

