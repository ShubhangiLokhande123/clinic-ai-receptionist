FROM python:3.12-slim

# Install uv
RUN pip install uv

# Set the working directory
WORKDIR /app

# Copy the dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 4444

# Start the application
CMD ["uv", "run", "python", "backend.py"]
