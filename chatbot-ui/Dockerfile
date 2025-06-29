FROM python:3.10.12-slim-bullseye AS builder

RUN pip install --upgrade pip

WORKDIR /usr/src/app/

COPY ./requirements.txt /usr/src/app/

# install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt


FROM python:3.10.12-slim-bullseye AS runtime

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Copy installed venv from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Set workdir
WORKDIR /usr/src/app/

# Copy app source
COPY chat_interface.py config.toml entrypoint.sh ./

# run entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

