#!/usr/bin/env python3

# ansible/inventory/dynamic.py
import json
import subprocess
import os

def get_terraform_output():
    # print("Current working directory:", os.getcwd())
    # print("Expected Terraform path:", os.path.abspath("../../terraform"))

    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            cwd="../terraform",  # Шлях до каталогу з Terraform
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error calling Terraform: {e}")
        exit(1)
    except FileNotFoundError as e:
        print(f"File not found: {e}")
        exit(1)

def main():
    tf_output = get_terraform_output()

    # Дані з Terraform
    ec2_public_ip = tf_output["ec2_info"]["value"]["public_ip"]
    redis_info = tf_output["redis_info"]["value"]
    rds_info = tf_output["rds_info"]["value"]
    rds_credentials = tf_output["rds_credentials"]["value"]

    # Інвенторі зі змінними
    inventory = {
        "all": {
            "hosts": ["wordpress_server"]
        },
        "_meta": {
            "hostvars": {
                "wordpress_server": {
                    "ansible_host": ec2_public_ip,
                    "ansible_user": "ec2-user",
                    "ansible_ssh_private_key_file": "~/.ssh/abz-key",
                    "redis_endpoint": redis_info["endpoint"],
                    "redis_port": redis_info["port"],
                    "rds_endpoint": rds_info["endpoint"].split(":")[0],
                    "rds_port": rds_info["port"],
                    "db_name": rds_credentials["db_name"],
                    "db_user": rds_credentials["db_user"],
                    "db_password": rds_credentials["db_password"]
                }
            }
        }
    }

    print(json.dumps(inventory, indent=4))

if __name__ == "__main__":
    main()
