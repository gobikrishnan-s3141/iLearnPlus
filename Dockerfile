# ilearnplus

# Miniforge image [pre-built ubuntu-base python env]
FROM condaforge/miniforge3

# set up environment (reduce package overhead)
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    BUILD_HOME=/build \
    PATH=/root/.local/bin:$PATH

# install dependencies
RUN apt-get update &&  apt-get install -y --no-install-recommends build-essential \
	adduser \
	git \
	libgl1 \
 	libglx-mesa0 \
	gfortran \
	zlib1g-dev && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# user
ARG USERNAME=mamba
ARG USERID=1001
RUN adduser --disabled-password --uid $USERID $USERNAME

# workspace
RUN mkdir -p $BUILD_HOME && chown -R $USERNAME:$USERNAME $BUILD_HOME
WORKDIR $BUILD_HOME

# (always specify exact version for python packages)
COPY --chown=$USERNAME:$USERNAME . .

# create conda env
RUN conda create -n ilearnplus python=3.12 && conda run -n ilearnplus pip install -r requirements.txt

# jupyter notebook
#CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
CMD ["python", "iLearnPlus.py"]
