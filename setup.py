import setuptools

setuptools.setup(
    name="dbz",
    version="0.0.1",
    author="dbz",
    description="Umbrella frontend for IKT446 project",
    packages=["dbz"],
    install_requires=['flask', 'requests', 'pandas', 'neo4j', 'Flask-PyMongo', 'Flask-SQLAlchemy', 'pymysql', 'python-dotenv', "simplejson"],
)
