#!/bin/bash
# Получаем использованную и общую память в MiB
used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)

# Вычисляем процент
percent=$(( used * 100 / total ))

# Выводим только процент
echo "${percent}%"
