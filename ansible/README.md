### Структура
```text
ansible/
├── inventory/
│   ├── dynamic.py             # Динамічний інвенторі
│   └── README.md              
├── playbook/
│   ├── wordpress_setup.yml    # Плейбук для налаштування WordPress
│   └── README.md
├── ansible.cfg                # Конфігурація Ansible              
└── README.md                  
```

```bash
ansible wordpress_server -m setup

ansible-playbook -i inventory/dynamic.py playbook/wordpress_setup.yml
```

### Перевірка результатів роботи провіжинінгу
`/var/www/html/wp-config.php`
```text
<?php
define('DB_NAME', 'wordpress_db'); // Назва бази даних
define('DB_USER', 'admin'); // Користувач бази даних
define('DB_PASSWORD', 'password'); // Пароль до бази даних
define('DB_HOST', 'terraform-20250120200331886200000007.c5sumg0cgft0.eu-west-1.rds.amazonaws.com'); // Хост бази даних
define('DB_CHARSET', 'utf8'); // Набір символів бази даних
define('DB_COLLATE', ''); // Сортування бази даних

define('WP_REDIS_HOST', 'abz-project-redis-cluster.ca2995.0001.euw1.cache.amazonaws.com'); // Хост Redis
define('WP_REDIS_PORT', 6379); // Порт Redis

$table_prefix = 'wp_'; // Префікс таблиць бази даних
define('WP_DEBUG', false); // Режим налагодження

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
```

### Перевірка RDS
```bash
ssh -i ~/.ssh/<key> ec2-user@<public ip>
mysql -u -u <db_user> -p<db_password> -h <endpoint> wordpress_db
MySQL [wordpress_db]> SHOW TABLES;
+------------------------+
| Tables_in_wordpress_db |
+------------------------+
| wp_commentmeta         |
| wp_comments            |
| wp_links               |
| wp_options             |
| wp_postmeta            |
| wp_posts               |
| wp_term_relationships  |
| wp_term_taxonomy       |
| wp_termmeta            |
| wp_terms               |
| wp_usermeta            |
| wp_users               |
+------------------------+
12 rows in set (0.00 sec)
```

### Перевірка Amazon ElastiCache-Redis
- Перед перевіркою заходимо в адмін панель WP і встановлюємо плагін Redis Object Cache, активуємо та вмикаємо

![Screenshot from 2025-01-21 01-04-28.png](../screenshots/Screenshot%20from%202025-01-21%2001-04-28.png)

- Робимо кілька переходів по сайту, перевіряємо роботу redis
```bash
redis-cli -h abz-project-redis-cluster.ca2995.0001.euw1.cache.amazonaws.com -p 6379 keys '*'
 1) "wp:options:nonce_salt"
 2) "wp:options:auth_salt"
 3) "wp:redis-cache:metrics"
 4) "wp:users:1"
 5) "wp:post_meta:3"
 6) "wp:site-options:1-notoptions"
 7) "wp:comment:last_changed"
 8) "wp:site-transient:update_core"
 9) "wp:userlogins:abz"
10) "wp:options:auth_key"
11) "wp:posts:3"
12) "wp:comment-queries:get_comments-af51e1447baeb6292f56d66e263216b8-0.41836600 1737412908"
13) "wp:options:logged_in_key"
14) "wp:site-transient:update_themes"
15) "wp:site-transient:theme_roots"
16) "wp:comment-queries:get_comments-5e1fdee937884a9ec249b6f5aa409f69-0.41836600 1737412908"
17) "wp:options:nonce_key"
18) "wp:options:notoptions"
19) "wp:user_meta:1"
``` 
