FROM python:3.9
WORKDIR /app

COPY ./requirements.txt /requirements.txt
COPY . .

RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

ENV WANDB_API_KEY=1db528eb82859f7e896db81de60999886637c51a
CMD ["python", "/app/main.py", "MR", "ALBERT", "--learning_rate=1e-5", "--batch_size=32", "--num_train_epochs=10", "--dropout=0"]