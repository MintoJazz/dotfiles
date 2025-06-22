#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot
## Adaptado para usar o tema padrão do Rofi.

# Elementos do menu
theme="~/.config/rofi/meu-tema/applets.rasi"
prompt='Screenshot'
mesg="Salvar em: `xdg-user-dir PICTURES`/Screenshots"

# Opções do menu (texto simples)
option_1=" Capturar Tela Inteira"
option_2=" Capturar Área"
option_3=" Capturar Janela"
option_4=" Capturar em 5s"
option_5=" Capturar em 10s"

# Comando Rofi simplificado para usar o tema padrão
rofi_cmd() {
    rofi -dmenu \
         -theme $theme\
         -p "$prompt" \
         -mesg "$mesg" \
         -markup-rows
}

# Passa as variáveis para o menu rofi
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Lógica de Screenshot (inalterada)
time=$(date +%Y-%m-%d-%H-%M-%S)
geometry=$(xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current')
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# notificar e visualizar screenshot
notify_view() {
    notify_cmd_shot='dunstify -u low --replace=699'
    ${notify_cmd_shot} "Copiado para a área de transferência."
    
    # Adicionando um pequeno atraso para o arquivo ser escrito no disco
    sleep 0.2

    # Verifica se o arquivo foi realmente criado antes de tentar abri-lo
    if [[ -e "${dir}/${file}" ]]; then
        viewnior "${dir}/${file}"
        ${notify_cmd_shot} "Screenshot Salvo."
    else
        ${notify_cmd_shot} "Captura cancelada ou falhou ao salvar."
    fi
}

# Copia screenshot para a área de transferência
copy_shot () {
    tee "$file" | xclip -selection clipboard -t image/png
}

# contagem regressiva
countdown () {
    for sec in $(seq $1 -1 1); do
        dunstify -t 1000 --replace=699 "Capturando em: $sec"
        sleep 1
    done
}

# Funções de captura
shotnow () {
    cd "${dir}" && maim -u -f png | copy_shot
    notify_view
}

shot5 () {
    countdown '5'
    cd "${dir}" && maim -u -f png | copy_shot
    notify_view
}

shot10 () {
    countdown '10'
    cd "${dir}" && maim -u -f png | copy_shot
    notify_view
}

shotwin () {
    cd "${dir}" && maim -i "$(xdotool getactivewindow)" -u -f png | copy_shot
    notify_view
}

shotarea () {
    cd "${dir}" && maim -s -b 2 -c 0.35,0.55,0.85,0.25 -l -u -f png | copy_shot
    notify_view
}

# Executa o comando escolhido
run_cmd() {
    case "$1" in
        --opt1) shotnow ;;
        --opt2) shotarea ;;
        --opt3) shotwin ;;
        --opt4) shot5 ;;
        --opt5) shot10 ;;
    esac
}

# Ações
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1")
        run_cmd --opt1
        ;;
    "$option_2")
        run_cmd --opt2
        ;;
    "$option_3")
        run_cmd --opt3
        ;;
    "$option_4")
        run_cmd --opt4
        ;;
    "$option_5")
        run_cmd --opt5
        ;;
esac