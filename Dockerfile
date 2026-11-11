# Multi-CVE Vulnerable Test Image for TigerGate Container Security QA
FROM python:3.8-slim

# Vulnerable dependencies with known Critical and High CVEs
RUN pip install --no-cache-dir \
    requests==2.28.0 \
    urllib3==1.26.5 \
    py==1.11.0 \
    Flask==2.2.0 \
    Jinja2==3.1.1 \
    Pillow==9.0.0 \
    cryptography==38.0.0 \
    PyYAML==5.4 \
    setuptools==57.0.0 \
    certifi==2022.12.7

# Injected test secrets for TigerGate Secret Scanner
ENV AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
ENV GITHUB_PAT="ghp_999999999999999999999999999999999999"
ENV DATABASE_PASSWORD="SuperSecretDBPassword!2026"

WORKDIR /app
CMD ["python3", "-c", "print('TigerGate Multi-CVE App Running')"]
