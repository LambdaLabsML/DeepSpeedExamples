# Usage

### Creat virtualenv to install dependencies

```
python -m venv venv-inference
pip install -r requirements.txt
```

### Set up environment variables in .env
```
# add PROJECT_PATH=<your-path-to-project> to .env
# add ENV_PATH=<your-path-to-python-virtualenv> to .env
# e.g. 
# PROJECT_PATH=/home/ubuntu/shared
# ENV_PATH=/home/ubuntu/env/venv-inference


# Then 
source .env
mkdir -p ${PROJECT_PATH}/.cache/huggingface/transformers
mkdir -p ${PROJECT_PATH}/.cache/huggingface/datasets
```

### Run bechmark

```
./run_opt66b.sh
```
