# azure-custom-role-cookiecutter

A cookiecutter template for creating a custom role for Azure resource

## How to use

```bash
$ pip install cookiecutter
$ coockiecutter https://github.com/openjny/azure-custom-role-cookiecutter

project_name [project name]: bastion reader     
project_slug [bastion_reader]: 
Select lang:
1 - en-us
2 - ja-jp
Choose from 1, 2 [1]: 2
subscription_id [your subscrition id]: 3f15978e-005c-b763-bb78-2a8fab289c58
role_name [your custom role name]: Bastion Reader
role_desc [description for your custome role]: Custom role for connecting VMs via Bastion

$ cd bastion_reader
```