#!/bin/bash
set -e

# Ensure required inputs are set
if [[ -z "$PROJECT_ID" || -z "$ENVIRONMENT_NAME" || -z "$APP_NAME" || -z "$COMPONENT_NAME" || -z "$VERSION" || -z "$ACCESS_KEY" || -z "$SECRET_KEY" || -z "$REGION" ]]; then
  echo "Error: Missing required inputs."
  exit 1
fi

# Set default EPI if not provided
EPI=${EPI:-0}


# Configure Huawei Cloud CLI non-interactively
/usr/bin/expect <<EOF
set timeout 10
spawn hcloud configure init
expect "Access Key ID \\[required\\]:"
send "$ACCESS_KEY\r"
expect "Secret Access Key \\[required\\]:"
send "$SECRET_KEY\r"
expect "Secret Access Key (again):"
send "$SECRET_KEY\r"
expect "Region:"
send "$REGION\r"
expect eof
EOF

# Set CLI language to Chinese
hcloud configure set --cli-lang=cn

echo "Huawei Cloud CLI configured successfully."

# Accept Huawei CLI Agreement
/usr/bin/expect <<EOF
set timeout 10
spawn hcloud
expect "Agree and continue (y)/Disagree and exit (N):"
send "y\r"
expect eof
EOF

# Get Environment ID
ENV_ID=$(hcloud CAE ListEnvironments --project_id="$PROJECT_ID" 2>/dev/null | jq -r ".items[] | select(.name == \"$ENVIRONMENT_NAME\") | .id")
if [ -z "$ENV_ID" ]; then
    echo "Error: Environment '$ENVIRONMENT_NAME' not found."
    exit 1
fi

echo "Found Environment ID: $ENV_ID"

# Get Application ID
APP_ID=$(hcloud CAE ListApplications --X-Environment-ID="$ENV_ID" --project_id="$PROJECT_ID" 2>/dev/null | jq -r ".items[] | select(.name == \"$APP_NAME\") | .id")
if [ -z "$APP_ID" ]; then
    echo "Error: Application '$APP_NAME' not found."
    exit 1
fi

echo "Found Application ID: $APP_ID"


# Get Component ID
COMPONENT_ID=$(hcloud CAE ListComponents --X-Environment-ID="$ENV_ID" --application_id="$APP_ID" --project_id="$PROJECT_ID" 2>/dev/null | jq -r ".items[] | select(.name == \"$COMPONENT_NAME\") | .id")
if [ -z "$COMPONENT_ID" ]; then
    echo "Error: Component '$COMPONENT_NAME' not found."
    exit 1
fi

echo "Found Component ID: $COMPONENT_ID"

# Get Component Details
RESPONSE=$(hcloud CAE ShowComponent --X-Environment-ID="$ENV_ID" --application_id="$APP_ID" --component_id="$COMPONENT_ID" --project_id="$PROJECT_ID" 2>/dev/null)
if [ -z "$RESPONSE" ]; then
    echo "Error: Failed to retrieve component details."
    exit 1
fi


echo "Component Details:"
echo "$RESPONSE" | jq .


# Extract auth_name, namespace, and URL
AUTH_NAME=$(echo "$RESPONSE" | jq -r '.spec.source.code.auth_name')
NAMESPACE=$(echo "$RESPONSE" | jq -r '.spec.source.code.namespace')
URL=$(echo "$RESPONSE" | jq -r '.spec.source.url')

# Ensure extracted values are valid
if [ -z "$AUTH_NAME" ] || [ -z "$NAMESPACE" ] || [ -z "$URL" ]; then
    echo "Error: Failed to extract required fields."
    exit 1
fi

# Execute Action
hcloud CAE ExecuteAction \
  --X-Environment-ID="$ENV_ID" \
  --api_version="v1" \
  --application_id="$APP_ID" \
  --component_id="$COMPONENT_ID" \
  --X-Enterprise-Project-ID="$EPI" \
  --kind="Action" \
  --project_id="$PROJECT_ID" \
  --metadata.name="upgrade" \
  --metadata.annotations.version="$VERSION" \
  --spec.source.type="code" \
  --spec.source.sub_type="GitHub" \
  --spec.source.url="$URL" \
  --spec.source.code.branch="main" \
  --spec.source.code.auth_name="$AUTH_NAME" \
  --spec.source.code.namespace="$NAMESPACE"

echo "Deployment successful."

# Cleanup sensitive data
unset ACCESS_KEY
unset SECRET_KEY
unset REGION
unset PROJECT_ID
unset ENVIRONMENT_NAME
unset APP_NAME
unset COMPONENT_NAME
unset VERSION
history -c
rm -f /home/runner/entrypoint.sh

echo "Sensitive data cleared."
