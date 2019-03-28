#!/bin/bash
set -e

# the miniconda directory may exist if it has been restored from cache
if [ -d "$MINICONDA_DIR" ] && [ -e "$MINICONDA_DIR/bin/conda" ]; then
    echo "Miniconda install already present from cache: $MINICONDA_DIR"
    export PATH="$MINICONDA_DIR/bin:$PATH"
    hash -r
else # if it does not exist, we need to install miniconda
    rm -rf "$MINICONDA_DIR" # remove the directory in case we have an empty cached directory
    curl -S https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > miniconda.sh;

    bash miniconda.sh -b -p "$MINICONDA_DIR"
    chown -R "$USER" "$MINICONDA_DIR"
    export PATH="$MINICONDA_DIR/bin:$PATH"
    hash -r
    conda config --set always_yes yes --set changeps1 no --set remote_max_retries 6
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    conda config --add channels broad-viral
    # Use recommendations from https://github.com/bioconda/bioconda-recipes/issues/13774
    conda update --quiet -y conda
    # conda config --set channel_priority strict
fi

# update certs
conda info -a # for debugging
