#!/bin/bash

# Defina aqui o caminho para a sua pasta de projetos
PROJECTS_DIR="$HOME/projects"

# Verifica se o diretório de projetos existe
if [ ! -d "$PROJECTS_DIR" ]; then
    wofi --show dmenu <<< "ERRO: Diretório '$PROJECTS_DIR' não encontrado."
    exit 1
fi

# Lista os subdiretórios, mostra no wofi, e armazena a escolha do usuário
# Usamos `basename` para mostrar apenas o nome da pasta, não o caminho completo
# `find ... -type d` garante que pegamos apenas diretórios
selected=$(find -L "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d | xargs -I {} basename {} | wofi --show dmenu -s ~/.config/wofi/styles.css --pro--style ~/.config/wofi/style.cssmpt="Abrir Projeto:")

# Se o usuário pressionar Esc ou não selecionar nada, `selected` estará vazio.
# O script então simplesmente termina.
if [ -z "$selected" ]; then
    exit 0
fi

# Abre o VS Code no diretório selecionado
code "$PROJECTS_DIR/$selected"
