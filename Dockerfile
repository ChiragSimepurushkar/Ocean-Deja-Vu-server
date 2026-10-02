# Use a lightweight Python base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies (needed for compiling some python packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install ONLY the necessary production serving dependencies
# We install PyTorch CPU-only version first to save massive amounts of RAM/Disk
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir fastapi uvicorn[standard] "zarr<3.0" numpy pandas scipy scikit-learn faiss-cpu httpx

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
