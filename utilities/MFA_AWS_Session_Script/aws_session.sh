#!/usr/bin/env bash

# Вказуємо ARN пристрою MFA
MFA_SERIAL_NUMBER="arn:aws:iam::0123456789:mfa/user"

# Видаляємо рядки зі змінними, якщо вони існують
remove_old_entries() {

sed -i '/AWS_ACCESS_KEY_ID/d; /AWS_SECRET_ACCESS_KEY/d; /AWS_SESSION_TOKEN/d' ~/.bashrc
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

source ~/.bashrc

}

# Перевіряємо, чи встановлені змінні середовища для сесії
if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" && -n "$AWS_SESSION_TOKEN" ]]; then
    echo "Виявлено активну сесію AWS CLI."
    echo "1 - завершити цю сесію та розпочати нову"
    echo "2 - завершити цю сесію"
    read -p "Введіть ваш вибір: " RESPONSE
    case $RESPONSE in
        1)
            # Видаляємо старі змінні з ~/.bashrc
            remove_old_entries

            echo "Активну сесію було завершено. Введіть MFA код з Вашого пристрою та натисніть Enter:"
            ;;
        2)
            # Видаляємо старі змінні з ~/.bashrc
            remove_old_entries

            echo "Активну сесію було завершено."
            exit 0
            ;;
        *)
            echo "Невідома опція: $RESPONSE"
            exit 1
            ;;
    esac
fi

# Запитуємо MFA код для створення нової сесії
read -p "Введіть MFA код з Вашого пристрою та натисніть Enter: " MFA_CODE

# Отримуємо тимчасові ключі за допомогою AWS CLI
OUTPUT=$(aws sts get-session-token --serial-number $MFA_SERIAL_NUMBER --token-code $MFA_CODE 2>&1)

if echo "$OUTPUT" | grep -q 'Credentials'; then
    remove_old_entries

    echo "export AWS_ACCESS_KEY_ID=$(echo "$OUTPUT" | jq -r '.Credentials.AccessKeyId')" >> ~/.bashrc
    echo "export AWS_SECRET_ACCESS_KEY=$(echo "$OUTPUT" | jq -r '.Credentials.SecretAccessKey')" >> ~/.bashrc
    echo "export AWS_SESSION_TOKEN=$(echo "$OUTPUT" | jq -r '.Credentials.SessionToken')" >> ~/.bashrc

    # Оновлюємо .bashrc
    source ~/.bashrc

    echo "Сесія встановлена успішно!"
    # Додаткова перевірка встановленої сесії
    aws sts get-caller-identity
else
    echo "Не вдалося отримати облікові дані. Будь ласка, перевірте ваш MFA код і спробуйте знову."
    echo "Помилка:"
    echo $OUTPUT
fi
