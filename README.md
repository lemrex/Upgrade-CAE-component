# **Huawei Cloud CAE Component Upgrade**  

![GitHub Marketplace](https://img.shields.io/badge/Marketplace-upgrade--CAE--component-blue)  
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
        uses: lemrex/Upgrade-CAE-component@v1.0.0
        with:
          project_id: ${{ secrets.HUAWEI_PROJECT_ID }}
          enterprise_project_id: "optional"
          environment_name: "environment name"
          app_name: "app name"
          component_name: "component name"
          version: "1.0.7"
          accessKey: ${{ secrets.ACCESSKEY }}
          secretKey: ${{ secrets.SECRETKEY }}
          region: "af-south-1"
```

---

## **Inputs**  


| Name                   | Description                                                                 | Required |
|------------------------|------------------------------------------------------------------------|----------|
| `project_id`          | Huawei Cloud Project ID. [`More Info`](https://support.huaweicloud.com/intl/en-us/api-cae/cae_06_0021.html) | ✅ Yes |
| `environment_name`    | Name of the environment                                                 | ✅ Yes |
| `app_name`            | Name of the application                                                 | ✅ Yes |
| `component_name`      | Name of the component                                                   | ✅ Yes |
| `version`            | Version to deploy                                                       | ✅ Yes |
| `accessKey`          | Huawei Cloud Access Key (AK)                                            | ✅ Yes |
| `secretKey`          | Huawei Cloud Secret Key (SK)                                            | ✅ Yes |
| `region`             | Huawei Cloud region (e.g., `af-south-1`)                                 | ✅ Yes |
| `enterprise_project_id` | ID of the Enterprise Project for resource isolation. Default is `0` (for default project). [`More Info`](https://support.huaweicloud.com/intl/en-us/usermanual-em/pm_topic_0003.html) | ❌ No (Defaults to `0`) |


---

## **Security Considerations**  

✅ **Sensitive Inputs Are Secured**  
- Use **GitHub Secrets** (`secrets.ACCESSKEY`, `secrets.SECRETKEY`, `secrets.PROJECT_ID`) instead of storing credentials in the workflow.  

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
- The **Project ID**  

---

## **Troubleshooting**  

🔹 **Invalid Credentials**  
- Ensure AK/SK are correct and have CAE permissions.  
- Check that you are using the **correct region** (`af-south-1`, `ap-southeast-1`, etc.).  

🔹 **Environment, Application, or Component Not Found**  
- Verify that the names match what is in **Huawei Cloud CAE**.  
- Run `hcloud CAE ListEnvironments` and `hcloud CAE ListApplications` manually.  

🔹 **Permission Issues**  
- Ensure your **IAM user** has the correct **CAE permissions**.  

---

## **REFERENCE**  

- [Huawei Cloud CAE API Documentation](https://support.huaweicloud.com/intl/en-us/productdesc-cae/cae_01_0001.html)
- [Enterprise Project Management](https://support.huaweicloud.com/intl/en-us/usermanual-em/pm_topic_0003.html)
- [Huawei Cloud CLI (`hcloud`) Guide](https://support.huaweicloud.com/intl/en-us/productdesc-hcli/hcli_01.html)

---

## **License**  
This project is licensed under the **MIT License**.  





