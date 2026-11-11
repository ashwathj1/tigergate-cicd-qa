# TigerGate CI/CD QA Testing Project

## Purpose
Comprehensive end-to-end QA testing of TigerGate Container Registry Scanning through Jenkins CI/CD.

## Directory Structure

```
tigergate-cicd-qa/
├── Jenkinsfile                          # Main local-scan pipeline
├── images/
│   ├── image1-normal/                   # Clean baseline image
│   ├── image2-outdated-os/              # Outdated Alpine OS packages
│   ├── image3-vuln-deps/                # Vulnerable Python/Java dependencies
│   ├── image4-secrets/                  # Embedded dummy secrets
│   ├── image5-misconfig/                # Dockerfile misconfigurations
│   └── image6-combined/                 # Combined: vulns + secrets + misconfig
├── pipelines/
│   ├── Jenkinsfile-local-scan           # Parameterized local scan (legacy)
│   ├── Jenkinsfile-registry-scan        # Build, push, scan from Docker Hub
│   └── Jenkinsfile-negative-tests       # Failure scenario testing
├── scripts/                             # Helper scripts
└── docs/                                # Test documentation and reports
```

## Quick Start

1. Ensure Jenkins credentials are configured:
   - `tigergate-api-key` (Secret text)
   - `dockerhub-credentials` (Username with password)

2. Create a Jenkins Pipeline job pointing to this repository.

3. Select the desired test image and scan type via Build Parameters.

## TigerGate CLI Reference (v1.2.2)

```
tigergate-scanner scan \
  --api-key <key> \
  --region <us1|eu1|in> \
  --image <image:tag> \
  --type <sast|sca|secrets|quality|iac|image|all> \
  --fail-on <severities> \
  --upload
```

## Test Images

| Image | Purpose | Expected Findings |
|-------|---------|-------------------|
| image1-normal | Baseline | Minimal |
| image2-outdated-os | OS vulns | Multiple CVEs in Alpine 3.14 |
| image3-vuln-deps | App deps | Python/Java CVEs (Log4Shell, etc.) |
| image4-secrets | Secrets | API keys, passwords, private keys |
| image5-misconfig | Dockerfile | Root user, latest tag, no healthcheck |
| image6-combined | All above | Multi-category findings |

