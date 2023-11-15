FROM python:3.8-slim-buster
WORKDIR /scrap
COPY ./requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
ENV scrap 1
COPY . .
CMD ["python", "src/app.py"]