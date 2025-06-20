FROM golang:1.23-bullseye

WORKDIR /app

# Fix sources.list to use HTTPS before installing packages
RUN sed -i 's|http://deb.debian.org|https://deb.debian.org|g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git ca-certificates \
    && update-ca-certificates

# Copy Go modules and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy application code
COPY . .

# Build the binary
RUN go build -o server .

# Expose the app port
EXPOSE 8080

# Run the app
CMD ["./server"]
