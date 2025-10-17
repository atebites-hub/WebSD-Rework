FROM ubuntu:24.04

RUN apt-get update && apt-get install -y python3.13 python3.13-venv python3.13-dev

RUN python3.13 -m venv /opt/venv-3.13
RUN /opt/venv-3.13/bin/python -m pip install --upgrade pip setuptools wheel pipx && pipx ensurepath

WORKDIR /workspace

COPY web-stable-diffusion/requirements.txt web-stable-diffusion/setup.py ./
RUN /opt/venv-3.13/bin/python -m pip install -r requirements.txt
RUN /opt/venv-3.13/bin/python -m pip install -e .