# Use an official Ubuntu runtime as a parent image
FROM ubuntu:20.04

# Set environment variables to non-interactive for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y cowsay fortune-mod netcat && \
    apt-get clean

# Copy the script into the container at /app
COPY wisecow.sh /app/wisecow.sh

# Make the script executable
RUN chmod +x /app/wisecow.sh

# Expose the port that the service will run on
EXPOSE 4499

# Run the script
CMD ["/app/wisecow.sh"]

