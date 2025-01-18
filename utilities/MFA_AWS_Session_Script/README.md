# MFA AWS Session Script

## Опис

Цей скрипт використовується для автоматизації процесу створення тимчасових AWS-сесій за допомогою MFA (Multi-Factor Authentication). Він перевіряє наявність активної сесії, дозволяє завершити її та створює нову, використовуючи команду `aws sts get-session-token`. Нові змінні середовища (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`) зберігаються у файлі `~/.bashrc` для подальшого використання.

## Вимоги

1. Встановлений `aws-cli`.
2. Встановлений `jq` для обробки JSON.
3. Налаштований MFA для AWS користувача.
4. Політика IAM для користувача, що забезпечує доступ лише через тимчасові токени.

## Як використовувати

1. Скопіюйте скрипт у файл (наприклад, `mfa-session.sh`).
2. Надайте права виконання:  
```bash
   chmod +x mfa-session.sh
```
## Політика IAM

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyLongTermKeys",
            "Effect": "Deny",
            "NotAction": "sts:GetSessionToken",
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:TokenIssueTime": true
                }
            }
        },
        {
            "Sid": "AllowAllActionsForSessionTokens",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:TokenIssueTime": false
                }
            }
        }
    ]
}
```

## Опис політики

### DenyLongTermKeys
- Забороняє **будь-які дії**, окрім `sts:GetSessionToken`, якщо використовуються **довготривалі ключі** (тобто запити без атрибута `aws:TokenIssueTime`).

### AllowAllActionsForSessionTokens
- Дозволяє **всі дії**, якщо запит виконується за допомогою **тимчасових токенів** (тобто запити з атрибутом `aws:TokenIssueTime`).

### Як це працює зі скриптом

- Скрипт працює виключно з тимчасовими токенами.
- Він перевіряє активну сесію, завершує її та створює нову за допомогою MFA.
- Нові змінні середовища (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`) зберігаються у `~/.bashrc` для зручності.

### Основна ідея

- **Довготривалі ключі(`aws_access_key_id` `aws_secret_access_key` `~/.aws/credentials`):** використовуються тільки для запиту тимчасових токенів через MFA.
- **Тимчасові токени:** автоматично деактивуються після завершення терміну дії, тому про ручну деактивацію можна не турбуватись.





