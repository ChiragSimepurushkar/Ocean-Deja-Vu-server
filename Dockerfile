# Use a lightweight Python base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies (needed for compiling some python packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install them
COPY backend/requirements.txt ./backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy all the backend code and data
COPY backend/ ./backend/

# Copy the server launch script
COPY start_server.py .

# Expose port 8000 for the Cloud Provider
EXPOSE 8000

# Set environment variables to enable the Live Model!
ENV PYTHONPATH=/app/backend
ENV ODV_LIVE_MODEL=1
ENV HOST=0.0.0.0
ENV PORT=8000

# Start the server
CMD ["python", "start_server.py"]
