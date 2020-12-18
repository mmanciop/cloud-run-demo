#!/usr/bin/env bash

url=$(terraform output nodejs_url)

ab -n 100000 -c 2 "$url/"
