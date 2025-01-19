# Опис команд AWS CLI для перевірки мережевої інфраструктури

## Команди та їх призначення
```bash
aws ec2 describe-internet-gateways --query "InternetGateways[*].{ID:InternetGatewayId,VPCs:Attachments[*].VpcId}" --output table
```
Повертає список усіх інтернет-шлюзів в обліковому записі AWS. Для кожного інтернет-шлюзу відображаються:
- Ідентифікатор шлюзу (ID).
- Ідентифікатори VPC (Virtual Private Cloud), до яких вони прикріплені.

```bash
aws ec2 describe-subnets --query "Subnets[*].{ID:SubnetId,VPC:VpcId,CIDR:CidrBlock,AZ:AvailabilityZone}" --output table
```
Виводить інформацію про всі підмережі у обліковці AWS. Для кожної підмережі показано:
- Ідентифікатор підмережі (ID).
- Ідентифікатор VPC, до якої належить підмережа.
- CIDR-блок підмережі.
- Зона доступності (Availability Zone), у якій знаходиться підмережа.

```bash
`aws ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId,State:State,Name:Tags[?Key=='Name']|[0].Value}" --output table`
```
Повертає інформацію про всі VPC у обліковці AWS. Для кожної VPC показано:
- Ідентифікатор VPC (ID).
- Стан VPC (наприклад, available).
- Тег з іменем VPC (Name), якщо він присутній.