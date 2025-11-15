#!/bin/bash


ADDRESS="$1"


if [ -z "$ADDRESS" ]; then
    read -p "Введите адрес для пинга: " ADDRESS
fi

echo "Начинаю мониторинг адреса: $ADDRESS"
echo "Интервал: 1 секунда"
echo

FAIL_COUNT=0

while true; do

    PING_OUTPUT=$(ping -c 1 "$ADDRESS" 2>/dev/null)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        ((FAIL_COUNT++))
        echo "Ping failed ($FAIL_COUNT/3)"
    else

        FAIL_COUNT=0


        TIME_MS=$(echo "$PING_OUTPUT" | grep 'time=' | sed 's/.*time=\([0-9.]*\).*/\1/')

        echo "Ping: ${TIME_MS} ms"


        TIME_INT=${TIME_MS%.*}
        if [ "$TIME_INT" -gt 100 ]; then
            echo "ВНИМАНИЕ: время отклика выше 100 ms!"
        fi
    fi


    if [ $FAIL_COUNT -ge 3 ]; then
        echo "Ошибка: 3 неудачных пинга подряд!"
        FAIL_COUNT=0
    fi

    sleep 1
done


