#!/bin/bash

# Remember to add executable rights to this bash script
# By using: chmod +x stop.sh

# To use this .sh => ./stop.sh

docker compose down

# docker compose down --volumes --remove-orphans --rmi all