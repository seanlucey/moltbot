# Moltbot Infrastructure

Self-hosted Moltbot deployment with infrastructure, configuration, and automation for local and AWS ECS environments.

This repository does **not** build Moltbot itself. Instead, it provides a clean, reproducible way to run the official `moltbot/moltbot` Docker image using the same configuration across local development and production.

---

## ✨ What This Repo Is

* A **control plane** for running Moltbot
* Environment-agnostic Moltbot configuration (gateway, channels, skills)
* Local development via Docker Compose
* Production deployment via AWS ECS (Fargate-friendly)
* Designed to scale to Terraform / multi-environment setups

---

## 🧱 Repository Structure

```text
moltbot-infra/
├── README.md
├── docker/
│   └── docker-compose.yml      # Local development
├── ecs/
│   ├── task-definition.json    # Reference ECS task definition
│   ├── service.json            # Reference ECS service
│   └── variables.env           # Runtime environment variables
├── terraform/
│   ├── modules/
│   │   └── ecs-moltbot/         # Reusable ECS module
│   └── envs/
│       ├── dev/
│       └── prod/
├── config/
│   ├── gateway.yaml             # Moltbot gateway config
│   ├── channels/                # Messaging channels (Telegram, Slack, etc.)
│   └── skills/                  # Installed / custom skills
├── scripts/
│   ├── bootstrap.sh             # Optional setup helpers
│   └── healthcheck.sh
└── .github/
    └── workflows/
        └── deploy.yml           # CI/CD automation
```

---

## 🚀 Quick Start (Local)

### Prerequisites

* Docker
* Docker Compose

### Run Moltbot Locally

```bash
cd docker
docker compose up
```

This will:

* Run the official `moltbot/moltbot` image
* Mount the local `config/` directory
* Expose the gateway on `http://localhost:18789`

Logs will stream to your terminal.

---

## ⚙️ Configuration

All Moltbot configuration lives in the `config/` directory.

### Key Files

* `config/gateway.yaml` – core Moltbot runtime configuration
* `config/channels/` – messaging platform configs (Telegram, Slack, etc.)
* `config/skills/` – enabled skills and defaults

This directory is mounted into the container at:

```text
/opt/moltbot/config
```

The same config is used **unchanged** across local, ECS, and future environments.

---

## ☁️ AWS ECS Deployment

This repo is designed for **ECS + Fargate**.

### Runtime Model

* Container image: `moltbot/moltbot`
* Config injected via volume or baked artifact
* Secrets sourced from:

  * AWS Secrets Manager
  * AWS SSM Parameter Store

### ECS Notes

* Non-root container execution
* Health checks via `/health`
* Stateless by default (data volume optional)

Terraform is the intended source of truth, but raw ECS JSON is included for reference and debugging.

---

## 🔐 Secrets & Environment Variables

No secrets should be committed to this repository.

Recommended approaches:

* AWS Secrets Manager
* AWS SSM Parameter Store
* `.env` file for local development only

Example variables:

```env
MOLTBOT_LOG_LEVEL=info
TELEGRAM_BOT_TOKEN=xxxx
OPENAI_API_KEY=xxxx
```

---

## 🧠 Design Principles

* **Runtime-agnostic** – same config everywhere
* **Immutable infrastructure** – no manual changes in prod
* **Local == Prod** – Docker Compose mirrors ECS
* **Minimal surface area** – Moltbot image remains upstream

---

## 🗺️ Roadmap

* [ ] Terraform ECS module
* [ ] Multi-environment config strategy
* [ ] Optional Ollama sidecar support
* [ ] GitHub Actions deployment pipeline
* [ ] Observability (CloudWatch / OpenTelemetry)

---

## 📜 License

MIT (or your preferred license)

---

## 💬 Notes

This repository is intentionally boring. That’s a feature.
Infrastructure should be predictable so Moltbot can be interesting.
