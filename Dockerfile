# Use official Mikroman image as base
FROM mikrowizard/mikroman:latest

WORKDIR /mikroman

# Set environment variables (optional defaults)
ENV PORT=8181
ENV SUPERUSER_EMAIL=admin@example.com
ENV SUPERUSER_PASSWORD=admin123

# Copy custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use our entrypoint
ENTRYPOINT ["/entrypoint.sh"]