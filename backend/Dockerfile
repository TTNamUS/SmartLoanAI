# FROM python:3.10.12-slim-bullseye

# RUN apt update -y \
#     && apt-get install \
#         python3-dev \
#         default-libmysqlclient-dev \
#         build-essential \
#         pkg-config -y \
#     && apt-get clean

# # Set working directory
# WORKDIR /appllm

# # Copy source code
# # copy content of src folder to appllm/src folder
# COPY src /appllm/src 

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE=1 \
#     PYTHONUNBUFFERED=1 \
#     PYTHONPATH="${PYTHONPATH}:/appllm:/appllm/src"

# # Expose port
# EXPOSE 8081

# # Copy and install dependencies
# COPY requirements.txt /appllm
# COPY requirements_sql_db.txt /appllm

# RUN pip install --no-cache-dir --upgrade pip \
#     && pip install --no-cache-dir -r requirements.txt \
#     && pip install --no-cache-dir -r requirements_sql_db.txt


# # Run the application
# CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8081", "--workers", "2", "--log-level", "info"]


# Multi-stage build để giảm kích thước image
FROM python:3.10.12-slim-bullseye AS builder

# Install build dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-dev \
        default-libmysqlclient-dev \
        build-essential \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /appllm

# Copy requirements first for better layer caching
COPY requirements.txt requirements_sql_db.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements_sql_db.txt

# Runtime stage
FROM python:3.10.12-slim-bullseye AS runtime

# Install only runtime dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /appllm

# Copy installed packages from builder stage
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy source code
COPY src /appllm/src

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH="/appllm:/appllm/src"

# Change ownership to non-root user
RUN chown -R appuser:appuser /appllm

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    # CMD curl -f http://localhost:8081/health || exit 1
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8081/health')" || exit 1

# Run the application
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8081", "--workers", "1", "--log-level", "info"]