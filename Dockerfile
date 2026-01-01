FROM ghcr.io/gethomepage/homepage:latest

# Set environment variables
ENV NODE_ENV=production

# Copy our local config to a defaults directory
# This will be used by run.sh to initialize the persistent volume
COPY config/ /app/config_defaults/

# Copy the startup script
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# The original image uses /app as WORKDIR
WORKDIR /app

# Expose the default port
EXPOSE 3000

# Use our script as the entrypoint
ENTRYPOINT ["/app/run.sh"]
