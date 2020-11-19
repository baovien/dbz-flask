# dbz
## Installation

Create a `.env` file in the dbz directory (or ask Bao for his `.env` file) 
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
cd dbz
pip install -e .
```

## Run the application

Go to project root and run `python -m dbz.app`.

