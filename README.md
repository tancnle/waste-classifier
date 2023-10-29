# waste-classifier

Waste Classifier Service using TensorFlow Serving and a Deep Learning Model.

## Getting started

### Prerequisites

- Python > 3.11
- [Poetry](https://python-poetry.org/)
- [Docker](https://www.docker.com/)

### Building the service

Install dependencies

```shell
poetry install
```

Build the Docker container with embedded model

```shell
make dockerize-model
```

Run the Docker container

```shell
make run
```

### Developing

Before committing and pushing changes, make sure to check for linting issues

```shell
make lint
```

To fix linting issue

```shell
make format
```

### Fetching predictions

In another terminal window, send a HTTP request to fetch predictions

```shell
$ poetry run ./predict samples/rubbish.jpg
{'cardboard': 0.182600647, 'glass': 0.0151944431, 'metal': 0.0774555057, 'paper': 0.114754409, 'plastic': 0.0962073, 'trash': 0.513787746}

$ poetry run ./predict samples/bottles.jpg
{'cardboard': 0.0585876703, 'glass': 0.0362069048, 'metal': 0.0567798503, 'paper': 0.0345257074, 'plastic': 0.0607169792, 'trash': 0.753182948}
```
