# waste-classifier

Waste Classifier Service using TensorFlow Serving and a Deep Learning Model.

## Getting started

### Prerequisites

- Python > 3.8
- [Poetry](https://python-poetry.org/)
- [Docker](https://www.docker.com/)

### Build the service

- Install dependencies

  ```shell
  poetry install
  ```

- Build the Docker container with embedded model

  ```shell
  make dockerize-model
  ```

- Run the Docker container

  ```shell
  make run
  ```

### Fetch predictions

- In another terminal window, send a HTTP request to fetch predictions
  ```shell
  $ ./predict rubbish.jpg
  {'cardboard': 0.182600647, 'glass': 0.0151944431, 'metal': 0.0774555057, 'paper': 0.114754409, 'plastic': 0.0962073, 'trash': 0.513787746}
  ```
