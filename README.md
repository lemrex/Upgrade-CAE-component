# **Huawei Cloud CAE Component Upgrade**  

This GitHub Action automates the upgrade of a **Component** in **Huawei Cloud Cloud Application Engine (CAE)** using the **Huawei Cloud CLI (hcloud)**.  

## **Features**  
✅ Secure authentication with **Access Key (AK) and Secret Key (SK)**  
✅ Retrieves **Environment, Application, and Component IDs** dynamically  
✅ Extracts **auth_name, namespace, and repository URL** for deployment  
✅ Executes the **"upgrade" action** for the specified component  
✅ Supports multiple **Huawei Cloud regions**  

---

## **Usage**  

### **1. Create a Workflow (`.github/workflows/deploy.yml`)**  

```yaml
name: Deploy to Huawei Cloud CAE

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Deploy Component
        uses: lemrex/upgrade-cae
        with:
          project_id: ${{ secrets.HUAWEI_PROJECT_ID }}
          enterprise_project_id: "optional"
          environment_name: "your-environment"
          app_name: "your-app"
          component_name: "your-component"
          version: "1.0.7"
          accessKey: ${{ secrets.HUAWEI_AK }}
          secretKey: ${{ secrets.HUAWEI_SK }}
          region: "cn-north-4"
```

---

## **Inputs**  

| Name               | Description                           | Required |
|--------------------|--------------------------------------|----------|
| `project_id`      | Huawei Cloud Project ID             | ✅ Yes |
| `environment_name`| Name of the environment             | ✅ Yes |
| `app_name`        | Name of the application             | ✅ Yes |
| `component_name`  | Name of the component               | ✅ Yes |
| `version`         | Version to deploy                   | ✅ Yes |
| `ak`             | Huawei Cloud Access Key (AK)        | ✅ Yes |
| `sk`             | Huawei Cloud Secret Key (SK)        | ✅ Yes |
| `region`         | Huawei Cloud region (e.g., `cn-north-4`) | ✅ Yes |

---

## **Security Considerations**  

✅ **Sensitive Inputs Are Secured**  
- Use **GitHub Secrets** (`secrets.HUAWEI_AK`, `secrets.HUAWEI_SK`) instead of storing credentials in the workflow.  

✅ **Automatic Credential Cleanup**  
- `hcloud configure clear` removes stored credentials after deployment.  
- `unset INPUT_AK INPUT_SK INPUT_REGION` clears environment variables.  
- `history -c` prevents sensitive information from being stored in shell history.  

✅ **Temporary Script Removal**  
- `rm -f /home/runner/entrypoint.sh` ensures the script is not accessible after execution.  

---

## **Prerequisites**  

- A **Huawei Cloud account**  
- **Access Key (AK) and Secret Key (SK)**  
- A **CAE environment, application, and component** already created  
- The **Huawei Cloud CLI (`hcloud`) installed**  

---

## **Troubleshooting**  

🔹 **Invalid Credentials**  
- Ensure AK/SK are correct and have CAE permissions.  
- Check that you are using the **correct region** (`cn-north-4`, `ap-southeast-1`, etc.).  

🔹 **Environment, Application, or Component Not Found**  
- Verify that the names match what is in **Huawei Cloud CAE**.  
- Run `hcloud CAE ListEnvironments` and `hcloud CAE ListApplications` manually.  

🔹 **Permission Issues**  
- Ensure your **IAM user** has the correct **CAE permissions**.  

---

## **License**  
This project is licensed under the **MIT License**.  

