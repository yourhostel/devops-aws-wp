### Тест з EC2 інстансу
```bash
sudo amazon-linux-extras enable redis6
sudo yum install -y redis
redis-cli --version

redis-cli -h <redis_endpoint> -p 6379
>PING
PONG
```