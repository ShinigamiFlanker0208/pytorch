FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

# Prevent frontend freezing during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential compilation tools and Python 3.12 PPA
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    curl \
    git \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Force system symlinks to target Python 3.12 natively
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

WORKDIR /workspace

# Install pip explicitly for Python 3.12
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# Copy and install the PyTorch matrix dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["tail", "-f", "/dev/null"]