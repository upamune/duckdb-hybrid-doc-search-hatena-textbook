#!/bin/bash -ue

git submodule update --init --recursive

docker build -t duckdb-hybrid-doc-search-hatena-textbook .
