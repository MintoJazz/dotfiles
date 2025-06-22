#!/usr/bin/env bash

# 1. Encerra instâncias de barras em execução
killall -q polybar

# 2. Aguarda até que os processos sejam finalizados
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Lança a Polybar em cada monitor detectado
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # A mágica acontece aqui: para cada monitor ($m), lança uma barra
    # e passa o nome do monitor para a variável de ambiente MONITOR.
    # Troque 'mybar' pelo nome da sua barra principal no config.ini
    MONITOR=$m polybar --reload mybar &
  done
else
  # Se xrandr não estiver disponível, lança uma única barra
  polybar --reload mybar &
fi

echo "Polybar lançada!"
