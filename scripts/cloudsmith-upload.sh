#!/bin/bash
set -euo pipefail

PLUGINS_VERSION=${1:?Must specify plugins version}
TAR_DIST=${2:?Must specify path to tar distribution}
ZIP_DIST=${3:?Must specify path to zip distribution}

ENV_DIR=./build/tmp/cloudsmith-env
if [[ -d ${ENV_DIR} ]] ; then
    source ${ENV_DIR}/bin/activate
else
    python3 -m venv ${ENV_DIR}
    source ${ENV_DIR}/bin/activate
fi

python3 -m pip install --upgrade cloudsmith-cli

cloudsmith push raw consensys/lina-besu-package $TAR_DIST --name "lina-besu-package-${PLUGINS_VERSION}.tar.gz" --version "${PLUGINS_VERSION}" --summary "lina-besu-package ${PLUGINS_VERSION} binary distribution" --description "Binary distribution of lina-besu-package ${PLUGINS_VERSION}." --content-type 'application/tar+gzip'
cloudsmith push raw consensys/lina-besu-package $ZIP_DIST --name "lina-besu-package-${PLUGINS_VERSION}.zip" --version "${PLUGINS_VERSION}" --summary "lina-besu-package ${PLUGINS_VERSION} binary distribution" --description "Binary distribution of lina-besu-package ${PLUGINS_VERSION}." --content-type 'application/zip'