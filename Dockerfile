FROM nvcr.io/nvidia/pytorch:23.04-py3 as base
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

RUN apt update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt-get install -y git curl libgl1 libglib2.0-0 libgoogle-perftools-dev \
	                   python3.10-dev python3.10-tk python3-html5lib python3-apt python3-pip python3.10-distutils && \
	rm -rf /var/lib/apt/lists/*

# Set python 3.10 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 3 && \
	update-alternatives --config python3

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

WORKDIR /app
RUN python3 -m pip install wheel

# Install torch for cu121 (only available as nightly as of writing)
RUN python3 -m pip install --no-cache-dir --use-pep517 -U torch>=2.1.0 --extra-index-url https://download.pytorch.org/whl/nightly/cu121

# Install requirements
COPY requirements.txt setup.py .
RUN python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt

# Replace pillow with pillow-simd
RUN python3 -m pip uninstall -y pillow && \
    CC="cc -mavx2" python3 -m pip install -U --force-reinstall pillow-simd

# Fix missing libnvinfer7
USER root
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvinfer.so /usr/lib/x86_64-linux-gnu/libnvinfer.so.7 && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.7

RUN useradd -m -s /bin/bash appuser
USER appuser
COPY --chown=appuser . .

STOPSIGNAL SIGINT
ENV LD_PRELOAD=libtcmalloc.so
ENV PATH="$PATH:/home/appuser/.local/bin"
CMD python3 "./kohya_gui.py" ${CLI_ARGS} --listen 0.0.0.0 --server_port 7860
