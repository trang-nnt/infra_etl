FROM apache/superset:latest
# Switching to root to install the required packages
USER root
ENV SUPERSET_SECRET_KEY="jfb112Jap-E7eGAYdQcgnxad3sAure3yhtOaL59mmPhrmIYkQUtnsO3RUO8CdZPNU_7-smVUpPzn9j4s4gCUSg"
# Example: installing the MySQL driver to connect to the metadata database
# if you prefer Postgres, you may want to use `psycopg2-binary` instead
RUN pip install psycopg2-binary
RUN pip install sqlalchemy-trino
RUN pip install Pillow
# Switching back to using the `superset` user
USER superset