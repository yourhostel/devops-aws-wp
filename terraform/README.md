## # Розгортання інфраструктури для WordPress на AWS

Створення інфраструктури для типового веб-застосунку за допомогою Terraform. Інфраструктура включає WordPress, базу даних MySQL RDS, ElastiCache Redis для збереження сесій, а також EC2 інстанс у приватній VPC.


### Структура файлів і модулів Terraform для розгортання інфраструктури
```text
terraform/
├── main.tf               # Головний файл для виклику модулів.
├── variables.tf          # Глобальні змінні, які використовуються в модулях.
├── terraform.tfvars      # Секретні дані та налаштування (в .gitignore).
└── modules/
    ├── ec2/              # Модуль для створення EC2.
    │   ├── main.tf       
    │   ├── variables.tf  
    │   └── outputs.tf    # Вихідні дані (публічна IP-адреса).
    ├── rds_mysql/        # Модуль для MySQL RDS.
    │   ├── main.tf       
    │   ├── variables.tf  
    │   └── outputs.tf    # endpoint бази даних.
    ├── elasticache_redis/ # Модуль для ElastiCache Redis.
    │   ├── main.tf       
    │   ├── variables.tf  
    │   └── outputs.tf    # endpoint Redis.
    ├── vpc/              # Модуль для створення VPC.
    │   ├── main.tf       
    │   ├── variables.tf  
    │   ├── outputs.tf    # private_subnet_ids public_subnet_ids vpc_id.
    │   └── README.md
    ├── security_group/   # Модуль для створення Security Groups.
    │   ├── main.tf       
    │   ├── variables.tf  
    │   └── outputs.tf    # список ID створених SG.     
    └── iam/              # Модуль для управління IAM.
        ├── main.tf       
        ├── variables.tf  
        ├── outputs.tf    # користувачі, політики.
        └── README.md     
```

### Додавання SSH пари ключ-значення в AWS, яке можна використовувати за його ім'ям під час розгортання EC2. Надалі це дасть змогу отримувати доступ до інстансу.

- Створити SSH-ключ локально
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/abz-key
```

-  Завантажити публічний ключ в AWS
```bash
aws ec2 import-key-pair --key-name "abz-key" --public-key-material fileb://~/.ssh/abz-key.pub
```

- Перевірити, що ключ доданий
```bash
aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" --output table
# очікуване виведення
------------------
|DescribeKeyPairs|
+----------------+
|  abz-key       |
+----------------+
```

- Альтернатива. Команда для створення SSH-ключа через AWS CLI:
```bash
aws ec2 create-key-pair --key-name abz-key --query "KeyMaterial" --output text > ~/.ssh/abz-key.pem
chmod 400 ~/.ssh/abz-key.pem

ls -l ~/.ssh/abz-key.pem
```

- Використання в terraform.tfvars
```hcl
key_name = "abz-key"
```

### Знайти відповідний AMI ID для Amazon Linux 2 в регіоні eu-west-1
```bash
aws ec2 describe-images --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --region eu-west-1 --query "Images[].[ImageId,Name,CreationDate]" --output table
```
