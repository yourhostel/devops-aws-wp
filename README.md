# devops-aws-wp

| **Resource**        | **vCPU** | **Memory** | **Hourly Cost** | **Type**     | **Storage**   | **Bandwidth** | **Region**     | **Notes**              |
|---------------------|----------|------------|-----------------|--------------|---------------|---------------|----------------|------------------------|
| **EC2 t3.micro**    | 2        | 1 GB       | $0.0104         | Burstable    | N/A           | Up to 5 Gbps  | eu-west-1      | Low-load tasks         |
| **RDS t3.micro**    | 2        | 1 GB       | $0.0167         | Burstable    | 20 GB SSD     | Moderate      | eu-west-1      | Single-AZ database     |
| **Redis t3.micro**  | 2        | 0.555 GB   | $0.017          | Burstable    | N/A           | Up to 5 Gbps  | eu-west-1      | Single-node cluster    |
