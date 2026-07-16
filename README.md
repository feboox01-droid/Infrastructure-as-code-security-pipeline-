## 🛡️ The Security Journey: Before vs. After

This project isn't just about secure code; it's about the **process** of catching and fixing risks.

### Phase 1: The Vulnerable State (Initial Code)
Initially, I intentionally wrote insecure Terraform code to test the pipeline:
- **S3 Bucket:** Created without `public_access_block`.
- **Security Group:** Allowed SSH (Port 22) from `0.0.0.0/0` (The entire internet).

**Result:** The GitHub Actions pipeline triggered and **FAILED**, flagging these critical risks:
- `CKV_AWS_20`: Public access block missing.
- `CKV_AWS_24`: SSH open to the world.

### Phase 2: Detection & Audit
The **Checkov scanner** caught these vulnerabilities before a single resource was actually created in AWS. This is the power of **Shift-Left Security**—catching the bug in the code, not in the cloud.

### Phase 3: Remediation (The Fix)
I updated the Terraform configuration to:
1.  Add `aws_s3_bucket_public_access_block` resource.
2.  Restrict SSH access to a specific private IP (`10.0.0.1/32`).
3.  Enable S3 Versioning and Encryption.

**Final Result:** The pipeline turned **GREEN** 🟢, ensuring only compliant infrastructure is deployed.
