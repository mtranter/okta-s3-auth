#! /usr/bin/env bash

set -euo pipefail

function target_build() {
  yarn build
}

function target_deploy() {
  target_build
  pushd ./infra
  terraform init
  terraform apply -auto-approve
  export WEBSITE_BUCKET=$(terraform output -raw website_bucket_name)
  export WEBSITE_URL=$(terraform output -raw website_url)
  export CF_DISTRO_ID=$(terraform output -raw cf_distro_id)
  popd

  pushd dist
  aws s3 sync ./ s3://$WEBSITE_BUCKET
  aws cloudfront create-invalidation \
    --distribution-id $CF_DISTRO_ID \
    --paths "/"
  popd
  echo "Done!"
  echo "Website should be available at $WEBSITE_URL"
}


helptext=$( cat <<EOF
Unknown command.
   $0 build        -- Builds the react app
   $0 deploy       -- Deploys the app
EOF
)


handler="target_$1"
if [[ $(type -t $handler) == function ]]; then
    shift 1
    $handler $*
else
    echo "$helptext"
fi