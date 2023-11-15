from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Create a PrometheusMetrics object with Flask app
metrics = PrometheusMetrics(app)

@app.route('/')
def hello_world():
    return 'Hello, World 2!'

if __name__ == '__main__':
    app.run()
