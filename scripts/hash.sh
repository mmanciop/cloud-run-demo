#!/usr/bin/env bash

hash=$(find "$1" -type f \( -exec sha1sum {} \; \) | sha1sum)

echo "{\"hash\": \"$hash\"}"