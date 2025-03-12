FROM ubuntu:22.04

# system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    postgresql-client \
    libpq-dev \
    netcat \
 && rm -rf /var/lib/apt/lists/*

# Poetry 
RUN pip3 install poetry

# Set the working directory
WORKDIR /app

# Copy dependency file first for caching then install dependencies without installing the root package
COPY pyproject.toml .
RUN poetry install --no-root

COPY todo todo

# shell command that waits for the database, then starts Flask
CMD ["bash", "-c", "until nc -z database 5432; do echo 'Waiting for database...'; sleep 2; done; poetry run flask --app todo run --host 0.0.0.0 --port 6400"]