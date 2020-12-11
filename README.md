# dbz

## Setup

Create a `.env` file in the dbz `(dbz-flask/dbz/.env)` directory. 

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

Activate your environment
```
conda activate <yourenvironment>
cd dbz-flask
```

Install the module
`pip install -e .`


## Run the application

Run `python -m dbz.app`

