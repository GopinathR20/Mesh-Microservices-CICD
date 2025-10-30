# Stage 1: Base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app source code
COPY . .

# Set Streamlit to listen on port 8080 for Azure Web App
ENV PORT=8080
ENV STREAMLIT_SERVER_PORT=8080
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0

# Expose port 8080
EXPOSE 8080

# Run Streamlit app
CMD ["streamlit", "run", "app.py"]
