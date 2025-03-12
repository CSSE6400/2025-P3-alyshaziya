FROM python:latest

# Install pipx
RUN apt-get update && apt-get install -y pipx
RUN pipx ensurepath

# Install poetry
RUN pip3 install poetry

# working directory
WORKDIR /app

#install poetry dependencies
COPY pyproject.toml ./
RUN pipx run poetry install --no-root

# copy app into container
COPY todo todo 

# run
CMD ["bash", "-c", "until nc -z database 5432; do echo 'Waiting for database...'; sleep 30; done; poetry run flask --app todo run --host 0.0.0.0 --port 6400"]
