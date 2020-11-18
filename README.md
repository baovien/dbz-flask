# dbz
## Installation

Create a `.env` file in the root directory. 
```
SERVER_IP=

# MySQL Credentials
MYSQL_URI=
MYSQL_USERNAME=
MYSQL_PASSWORD=
MYSQL_PORT=

# Neo4j Credentials
NEO_URI=
NEO_USERNAME=
NEO_PASSWORD=
NEO_PORT=

# MongoDB Credentials
MONGO_URI=
MONGO_USERNAME=
MONGO_PASSWORD=
MONGO_PORT=

```

Install the environment
```
conda env create -f environment.yml
conda activate flask
```

## Run the application

Go to project root and run `python app.py`.

`!TODO: create setup.py and install as module`
