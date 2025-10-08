#!/bin/bash

LATITUDE="49.9935"
LONGITUDE="36.2304"

WEATHER_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LATITUDE}&longitude=${LONGITUDE}&current=temperature_2m,weather_code,is_day&temperature_unit=celsius&forecast_days=1")

TEMPERATURE=$(echo "$WEATHER_DATA" | jq -r '.current.temperature_2m | floor')
WEATHER_CODE=$(echo "$WEATHER_DATA" | jq -r '.current.weather_code')
IS_DAY=$(echo "$WEATHER_DATA" | jq -r '.current.is_day')

# 0: Clear sky (Ясно)
# 1, 2, 3: Mainly clear, partly cloudy, overcast (В основном ясно, переменная облачность, пасмурно)
# 45, 48: Fog and depositing rime fog (Туман и изморозь)
# 51, 53, 55: Drizzle: Light, moderate, and dense intensity (Морось: легкая, умеренная, сильная)
# 56, 57: Freezing Drizzle: Light and dense intensity (Ледяная морось)
# 61, 63, 65: Rain: Slight, moderate, and heavy intensity (Дождь: слабый, умеренный, сильный)
# 66, 67: Freezing Rain: Light and heavy intensity (Ледяной дождь)
# 71, 73, 75: Snow fall: Slight, moderate, and heavy intensity (Снегопад: слабый, умеренный, сильный)
# 77: Snow grains (Снежные зерна)
# 80, 81, 82: Rain showers: Slight, moderate, and violent (Ливневый дождь)
# 85, 86: Snow showers: Slight and heavy (Ливневый снег)
# 95: Thunderstorm: Slight or moderate (Гроза: слабая или умеренная)
# 96, 99: Thunderstorm with slight and heavy hail (Гроза с градом)

WEATHER_ICON=""

if [ "$IS_DAY" -eq 1 ]; then # Дневное время
    case "$WEATHER_CODE" in
        0) WEATHER_ICON="☀️";; # Ясно
        1|2|3) WEATHER_ICON="☁️";; # Облачно
        45|48) WEATHER_ICON="🌫️";; # Туман
        51|53|55|56|57|61|63|65|66|67|80|81|82) WEATHER_ICON="🌧️";; # Дождь
        71|73|75|77|85|86) WEATHER_ICON="🌨️";; # Снег
        95|96|99) WEATHER_ICON="⛈️";; # Гроза
        *) WEATHER_ICON="❓";; # Неизвестно
    esac
else # Ночное время
    case "$WEATHER_CODE" in
        0) WEATHER_ICON="🌙";; # Ясно (ночь)
        1|2|3) WEATHER_ICON="☁️";; # Облачно
        45|48) WEATHER_ICON="🌫️";; # Туман
        51|53|55|56|57|61|63|65|66|67|80|81|82) WEATHER_ICON="🌧️";; # Дождь
        71|73|75|77|85|86) WEATHER_ICON="🌨️";; # Снег
        95|96|99) WEATHER_ICON="⛈️";; # Гроза
        *) WEATHER_ICON="❓";; # Неизвестно
    esac
fi

echo "${WEATHER_ICON} ${TEMPERATURE}°C"
