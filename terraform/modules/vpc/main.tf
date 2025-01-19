# modules/vpc/main.tf

# VPC
# Основна мережа з простором адрес 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"         # CIDR-діапазон для мережі
  enable_dns_support   = true                  # Включення підтримки DNS
  enable_dns_hostnames = true                  # Дозволяє використовувати імена хостів
  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Отримання списку доступних зон доступності (AZ) для створення підмереж
data "aws_availability_zones" "available" {
  state = "available"
}

# Публічні підмережі
# Використовуються для EC2, які мають доступ до інтернету
resource "aws_subnet" "public" {
  count                   = 2                                      # Кількість підмереж (одна на зону доступності)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]   # CIDR-діапазон для кожної підмережі
  map_public_ip_on_launch = true                                   # Автоматичне призначення публічного IP
  availability_zone       = data.aws_availability_zones.available.names[count.index] # Розподіл по зонам доступності
  tags = merge(var.tags, {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  })
}

# Приватні підмережі
# Використовуються для ресурсів без прямого доступу до інтернету (наприклад, RDS)
resource "aws_subnet" "private" {
  count             = 2                                             # Кількість підмереж (одна на зону доступності)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]         # CIDR-діапазон для кожної підмережі
  availability_zone = data.aws_availability_zones.available.names[count.index] # Розподіл по зонам доступності
  tags = merge(var.tags, {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  })
}

# Інтернет-шлюз
# Забезпечує доступ до інтернету для публічних підмереж
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.project_name}-internet-gateway"
  })
}

# Таблиця маршрутів для публічних підмереж. Включає маршрут до інтернет-шлюзу
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.project_name}-public-route-table"
  })
}

# Маршрут до інтернету для публічних підмереж
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id       # Таблиця маршрутів для публічних підмереж
  destination_cidr_block = "0.0.0.0/0"                     # Усі зовнішні адреси
  gateway_id             = aws_internet_gateway.main.id    # Інтернет-шлюз як вихідна точка
}

# Асоціація таблиці маршрутів із публічними підмережами
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)               # Для кожної публічної підмережі
  subnet_id      = aws_subnet.public[count.index].id       # Ідентифікатор підмережі
  route_table_id = aws_route_table.public.id               # Ідентифікатор таблиці маршрутів
}

# Таблиця маршрутів для приватних підмереж
# Для внутрішніх з'єднань без прямого доступу до інтернету
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id                 # Прив'язка до основної VPC
  tags = merge(var.tags, {
    Name = "${var.project_name}-private-route-table" # Назва таблиці маршрутів
  })
}

# Асоціація таблиці маршрутів із приватними підмережами
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)              # Для кожної приватної підмережі
  subnet_id      = aws_subnet.private[count.index].id      # Ідентифікатор підмережі
  route_table_id = aws_route_table.private.id              # Ідентифікатор таблиці маршрутів
}
