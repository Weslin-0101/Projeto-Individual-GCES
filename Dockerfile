FROM python:3.10

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY /short-poetry/pyproject.toml /pyproject.toml
COPY /short-poetry/poetry.lock /poetry.lock

ENV PATH="$PATH:/root/.local/bin" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VERSION=1.5.1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry'

RUN curl -sSL https://install.python-poetry.org | python3 - \
    && poetry --version

RUN poetry install

RUN mkdir /app
WORKDIR /app
COPY ./data/ /app/data/
COPY ./convert2dadgnn.py /app/convert2dadgnn.py
COPY ./convert2hypergat.py /app/convert2hypergat.py
COPY ./convert2inductTGCN.py /app/convert2inductTGCN.py
COPY ./convert2SHINE.py /app/convert2SHINE.py
COPY ./data.py /app/data.py
COPY ./Ensemble_models.py /app/Ensemble_models.py
COPY ./models.py /app/models.py
COPY ./main.py /app/main.py

RUN pip install --upgrade pip

ENV WANDB_API_KEY=1db528eb82859f7e896db81de60999886637c51a
CMD ["python", "/app/main.py", "MR", "ALBERT", "--learning_rate=1e-5", "--batch_size=32", "--num_train_epochs=10", "--dropout=0"]