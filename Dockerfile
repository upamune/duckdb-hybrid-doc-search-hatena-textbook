FROM ghcr.io/upamune/duckdb-hybrid-doc-search:latest AS builder

# Define build arguments with defaults
ARG DOCS_DIR=./docs
ARG MODEL=cl-nagoya/ruri-v3-310m

# Copy documents from specified directory
COPY ${DOCS_DIR} /docs

# Create index with specified model
RUN duckdb-hybrid-doc-search index /docs \
    --db /app/index.duckdb \
    --embedding-model ${MODEL}

# Create final image
FROM ghcr.io/upamune/duckdb-hybrid-doc-search:latest

# Copy index file from builder
COPY --from=builder /app/index.duckdb /app/index.duckdb

WORKDIR /app

# Run the server
CMD ["serve", "--db", "/app/index.duckdb", "--rerank-model", "cl-nagoya/ruri-v3-reranker-310m"]
