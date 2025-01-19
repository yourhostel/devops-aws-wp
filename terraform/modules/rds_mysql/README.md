### Тест з EC2 інстансу

```bash
sudo yum install -y mysql
mysql -h <rds_endpoint> -u admin -p

SHOW DATABASES;

MySQL [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wordpress_db       |
+--------------------+
5 rows in set (0.00 sec)
```