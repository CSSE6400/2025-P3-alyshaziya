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
CMD ["bash", "-c", "sleep 10 && pipx run poetry run flask \
    --app todo run --host 0.0.0.0 --port 6400"]