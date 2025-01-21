# Динамічний інвенторі з перевірочними командами

## Опис файлу `dynamic.py`

Файл `dynamic.py` автоматично отримує дані з Terraform і створює динамічний інвенторі для Ansible. Цей інвенторі містить інформацію про:
- Хости
- Параметри підключення (IP-адресу, користувача, ключ SSH).
- Змінні для налаштування WordPress (база даних, Redis).

## Команди перевірки

### Запуск скрипта напряму

Щоб перевірити, чи скрипт працює коректно:

```bash
python3 inventory/dynamic.py
```

Очікуваний результат:
```json
{
    "all": {
        "hosts": [
            "wordpress_server"
        ]
    },
    "_meta": {
        "hostvars": {
            "wordpress_server": {
                "ansible_host": "34.240.197.155",
                "ansible_user": "ec2-user",
                "ansible_ssh_private_key_file": "~/.ssh/abz-key",
                "redis_endpoint": "abz-project-redis-cluster.ca2995.0001.euw1.cache.amazonaws.com",
                "redis_port": 6379,
                "rds_endpoint": "terraform-20250120123606155800000007.c5sumg0cgft0.eu-west-1.rds.amazonaws.com",
                "rds_port": 3306,
                "db_name": "wordpress_db",
                "db_user": "admin",
                "db_password": "securepassword123"
            }
        }
    }
}

```

### Використання інвенторі в Ansible

Перевірка інвенторі через Ansible:

```bash
ansible-inventory --list
```

Очікуваний результат:
```json
{
    "_meta": {
        "hostvars": {
            "wordpress_server": {
                "ansible_host": "34.240.197.155",
                "ansible_ssh_private_key_file": "~/.ssh/abz-key",
                "ansible_user": "ec2-user",
                "db_name": "wordpress_db",
                "db_password": "password",
                "db_user": "admin",
                "rds_endpoint": "terraform-20250120123606155800000007.c5sumg0cgft0.eu-west-1.rds.amazonaws.com",
                "rds_port": 3306,
                "redis_endpoint": "abz-project-redis-cluster.ca2995.0001.euw1.cache.amazonaws.com",
                "redis_port": 6379
            }
        }
    },
    "all": {
        "children": [
            "ungrouped"
        ]
    },
    "ungrouped": {
        "hosts": [
            "wordpress_server"
        ]
    }
}

```

### Перевірка підключення до сервера

Щоб перевірити, чи Ansible може підключитися до сервера:

```bash
ansible wordpress_server -m ping
```

Очікуваний результат:
```text
wordpress_server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```