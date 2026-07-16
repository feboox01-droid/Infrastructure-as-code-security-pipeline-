# Project 1: DevSecOps Infrastructure-as-Code (IaC) Security Pipeline

## 📌 Overview
This project demonstrates a **Shift-Left Security** approach by integrating automated security scanning into a CI/CD pipeline. It prevents insecure AWS infrastructure (Terraform) from being deployed by scanning for vulnerabilities during the code-push phase.

## 🛠 Tech Stack
- **IaC Tool:** Terraform
- **Cloud Provider:** AWS
- **Security Scanner:** Checkov (Static Analysis Security Testing - SAST)
- **CI/CD Platform:** GitHub Actions

## 🛡️ Security Features Implemented
- **Automated Scanning:** Every push to `main` triggers a security audit.
- **S3 Hardening:** Detects public buckets, missing encryption, and missing versioning.
- **Network Security:** Scans for overly permissive Security Groups (e.g., SSH open to 0.0.0.0/0).
- **Audit Mode:** Configured with `soft_fail` to provide visibility into risks without breaking developer velocity (ideal for initial security onboarding).

## 🚀 How it Works
1. A developer writes Terraform code in `main.tf`.
2. Code is pushed to GitHub.
3. **GitHub Actions** spins up a container and runs **Checkov**.
4. Checkov scans the code against 1000+ cloud security best practices.
5. Results are displayed in the GitHub Actions console for the security team to review.

## 📊 Sample Findings (from Logs)
- `CKV_AWS_20`: Ensure S3 bucket has public access block.
- `CKV_AWS_24`: Ensure no security groups allow ingress from 0.0.0.0/0 to port 22.
