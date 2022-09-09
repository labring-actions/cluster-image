#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-tekton}
readonly VERSION=${3:-v0.61.0}

rm -rf charts
mkdir -p charts
cd charts && {
  # https://projectcalico.docs.tigera.io/release-notes/
  wget -qO- "https://github.com/tektoncd/operator/releases/download/$NAME-operator-${VERSION#*v}/$NAME-operator-${VERSION#*v}.tgz" | tar -zx
  mv "$NAME-operator" "$NAME"
  find . -type f -name "*.tmpl" -exec mv -v {} {}.bak \;
  while IFS= read -r f; do
    mv "$f" "$f".bak
    sed '/{{/d' "$f".bak >"$f"
  done < <(grep -rl "^kind: CustomResourceDefinition$" . | grep -v /openshift)
  cat <<EOF >"$NAME/Images"
$(
    while IFS= read -r image; do
      echo "${image//\"/}:$VERSION"
    done < <(
      grep -r /tekton-releases/ . | awk '{print $(NF-1)}' | grep /tekton-releases/ |
        grep -v /openshift/
    )
    grep -r /tekton-releases/ . | awk '{print $NF}' | grep /tekton-releases/ |
      awk -F@ '{print $1}'
  )
EOF
  cd -
}

mkdir -p manifests
cd manifests && {
  wget -qO components.yaml "https://github.com/tektoncd/operator/raw/$VERSION/components.yaml"
  while IFS= read -r component; do
    component_github="$(yq ".$component.github" components.yaml)"
    component_version="$(yq ".$component.version" components.yaml)"
    case $component in
    chains)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/release.yaml"
      ;;
    dashboard)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/tekton-dashboard-release.yaml"
      ;;
    hub)
      for yaml in api-kubernetes.yaml db-migration.yaml db.yaml ui-kubernetes.yaml; do
        wget -qO "${component_github//\//_}.$component_version.$yaml" \
          "https://github.com/$component_github/releases/download/$component_version/$yaml"
      done
      ;;
    pipeline)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/release.yaml"
      ;;
    pipelines-as-code)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/release.k8s.yaml"
      ;;
    results)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/release.yaml"
      ;;
    triggers)
      wget -qO "${component_github//\//_}.$component_version.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/release.yaml"
      wget -qO "${component_github//\//_}.$component_version.interceptors.yaml" \
        "https://github.com/$component_github/releases/download/$component_version/interceptors.yaml"
      ;;
    esac
  done < <(yq '.|keys' components.yaml | awk '{print $NF}')
  cd -
}

if [[ -s "charts/$NAME/Images" ]]; then
  mkdir -p images/shim
  cp "charts/$NAME/Images" "images/shim/${NAME}Images"
fi
