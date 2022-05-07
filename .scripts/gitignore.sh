#!/bin/bash

curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$@" > "$(pwd)/.gitignore"
