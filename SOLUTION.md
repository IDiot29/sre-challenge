# 🐾 SRE Challenge Write-up: Pixel Pet API

Hi team 👋,
This markdown outlines how I approached and implemented the challenge requirements across **core service development**, **operational excellence**, **automation**, and **local dev setup** — with thoughtful decision-making in each.
I am really Sorry for the delay in submission. I have been busy with my current job and I wanted to make sure I give my best to this challenge. I am sorry also for any mistakes that may have been made.

---

## ✅ 1. Core Service

**What I built:**
A RESTful Go microservice to manage virtual pets, each with happiness, hunger, and energy. It supports full CRUD over MongoDB.

**Endpoints include:**
- `POST /pets` – Create a pet
- `GET /pets` – Get all pets
- `GET /pets/{id}` – Get one by ID
- `PUT /pets/{id}` – Update a pet
- `DELETE /pets/{id}` – Delete a pet

**Additions:**
- `/` returns a basic welcome message.
- `/healthcheck` for readiness probe.
- `/metrics` exposes Prometheus-compatible metrics.

**Key files:**
- `src/controllers/pet_controller.go` – all handlers
- `src/routes/` – route groups
- `src/models/pet.go` – Pet model

---

## 🔧 2. Operational Requirements

### 📦 Containerization
The app is containerized via a **Dockerfile** at the project root, which builds from the Go binary and runs it with a minimal Alpine base.

### 🩺 Monitoring
- **Prometheus** scrapes metrics from `/metrics`
- **Grafana** used for dashboards
- **Alertmanager** sends dummy email alerts
- Alerts include:
  - API Down
  - High CPU Usage
  - High Memory Usage

Configured in:
- `infra/add-ons/monitoring/alert_rules.yml`
- `infra/add-ons/monitoring/prometheus.yml`
- `infra/add-ons/monitoring/alertmanager.yml`

### 📚 Runbooks
I created Markdown runbooks for:
- High CPU
- High Memory
- API Down

Located in: `infra/add-ons/runbooks/`

Each runbook covers:
- Symptoms
- Possible causes
- Investigation steps
- Resolution strategies

### 📜 Logging
- JSON-formatted logs to `stdout` (great for ingestion by any log stack)
- Structured log fields: timestamp, path, method, status, duration, etc.
- Middleware in `utils/logger.go` handles automatic request logging.

---

## 🤖 3. Automation

### 🔄 CI/CD with GitHub Actions

Implemented in `.github/workflows/main.yml`:
- ✅ Checkout, build, and test the Go code
- ✅ Spin up MongoDB (GitHub Actions `services`)
- ✅ Build Docker image
- ✅ Push image to Docker Hub

Secrets needed:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

### 🛠️ Infrastructure-as-Code
Terraform + Terragrunt used to provision:
- VPC
- MongoDB-compatible EC2
- ECR
- Route53 (DNS)
- ACM
- ALB + Auto Scaling Group

Defined in: `infra/terraform/`

Bonus: Includes a `deploy.sh` that scales up ASG and waits for health.

### 💬 Automation Decisions
Logged in `AUTOMATION.md` (you can create this):
- Why GitHub Actions
- CI flow logic
- Docker Hub registry decisions
- Reuse of Go modules from `src/`
- Services provisioned with Terraform

---

## 🧪 4. Local Development

All local development is Dockerized with:

- `docker-compose.yml`: spins up MongoDB
- `.env.example`: MONGODB_URI config
- `Dockerfile`: Go app image

**To run locally:**
```bash
docker-compose up
cd src
go mod download
go run main.go
```

**To test manually:**
```bash
curl localhost:8080/healthcheck
curl localhost:8080/pets
```

---

## 🚀 Extras

- `/metrics` and `/healthcheck` routed via Go mux router
- Logging middleware automatically tracks each hit
- Full test coverage for `/pets` endpoints via `src/tests/pet_test.go`

---

## ✅ Summary

| Section             | Status   | Notes |
|---------------------|----------|-------|
| Core Service        | ✅ Done   | Full CRUD with MongoDB |
| Monitoring & Logs   | ✅ Done   | Prometheus, Grafana, Alertmanager, JSON logs |
| Automation (CI/CD)  | ✅ Done   | GitHub Actions + Docker build/push |
| Infra as Code       | ✅ Done   | Terraform + Terragrunt |
| Local Dev           | ✅ Done   | Docker-based |
| Runbooks            | ✅ Done   | Markdown style |
| Alerts              | ✅ Done   | Memory, CPU, API down |

---

Let me know if you’d like this as a `SOLUTION.md` file or pushed into `README.md` with badges, diagrams, or visuals.

Also happy to create a visual architecture diagram or an alert dashboard preview if needed!
