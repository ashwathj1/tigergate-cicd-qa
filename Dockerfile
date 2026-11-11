# Multi-CVE Vulnerable Test Image for TigerGate Container Security QA
# Base contains 57 Critical and 495 High CVEs (OS packages + Python deps)
FROM tg-qa-combined:v1

# Injected test secrets for TigerGate Secret Detection
ENV AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
ENV GITHUB_PAT="ghp_999999999999999999999999999999999999"
ENV DATABASE_PASSWORD="SuperSecretDBPassword!2026"

WORKDIR /app
CMD ["python3", "app.py"]
