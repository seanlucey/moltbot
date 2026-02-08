# ---- Base image ----
FROM node:22-slim

# ---- Environment ----
ENV NODE_ENV=production
ENV MOLTBOT_HOME=/opt/moltbot

# ---- System deps ----
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    tini \
  && rm -rf /var/lib/apt/lists/*

# ---- Create app user ----
RUN useradd -m -u 10001 moltbot

# ---- Working directory ----
WORKDIR ${MOLTBOT_HOME}

# ---- Install Moltbot CLI ----
RUN npm install -g moltbot@latest

# ---- Create required directories ----
RUN mkdir -p \
    ${MOLTBOT_HOME}/config \
    ${MOLTBOT_HOME}/data \
    ${MOLTBOT_HOME}/logs \
  && chown -R moltbot:moltbot ${MOLTBOT_HOME}

# ---- Switch to non-root user ----
USER moltbot

# ---- Expose gateway port (adjust if needed) ----
EXPOSE 18789

# ---- Healthcheck (ECS-compatible) ----
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD curl -f http://localhost:18789/health || exit 1

# ---- Entrypoint ----
ENTRYPOINT ["/usr/bin/tini", "--"]

# ---- Default command ----
CMD ["moltbot", "gateway", "start", "--config", "/opt/moltbot/config"]
