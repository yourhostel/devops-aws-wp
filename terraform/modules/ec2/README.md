# Опис команд AWS CLI для перевірки EC2 інстансів

## Команди та їх призначення

```bash
aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,IP:PublicIpAddress}" --output table
```
Повертає список усіх EC2 інстансів в обліковому записі AWS. Для кожного інстансу відображаються:
- Ідентифікатор інстансу (ID).
- Стан інстансу (наприклад, running, stopped).
- Тип інстансу (наприклад, t2.micro).
- Публічна IP-адреса інстансу.

```bash
aws ec2 describe-security-groups --query "SecurityGroups[*].{ID:GroupId,Name:GroupName,VPC:VpcId,Description:Description}" --output table
```
Повертає список усіх груп безпеки (Security Groups) в обліковці AWS. Для кожної групи показано:
- Ідентифікатор групи (ID).
- Назва групи (Name).
- Ідентифікатор VPC, до якої належить група.
- Опис групи.

```bash
aws ec2 describe-volumes --query "Volumes[*].{ID:VolumeId,Size:Size,State:State,AZ:AvailabilityZone}" --output table
```
Повертає список усіх томів EBS, доступних в обліковому записі AWS. Для кожного тому показано:
- Ідентифікатор тому (ID).
- Розмір тому у гігабайтах (Size).
- Стан тому (наприклад, in-use, available).
- Зона доступності (Availability Zone), у якій знаходиться том.

```bash
aws ec2 describe-key-pairs --query "KeyPairs[*].{Name:KeyName,ID:KeyPairId}" --output table
```
Повертає список усіх пар ключів, доступних в обліковому записі AWS. Для кожної пари ключів відображаються:
- Назва пари ключів (Name).
- Ідентифікатор пари ключів (ID).