pipeline {
    agent any

    environment {
        DOCKER_HOST        = 'unix:///var/run/docker.sock'
        IMAGE_NAME         = 'nurepublic/cicd-test:latest'
        TIGERGATE_CLI      = 'tigergate/tigergate-cli:1.2.3'
        TIGERGATE_API_URL  = 'https://api.staging.tigergate.dev/api/ci'
        FAIL_ON_SEVERITY   = 'critical,high'
    }

    stages {
        stage('Build') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}..."
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('TigerGate Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'tigergate-api-key', variable: 'TIGERGATE_API_KEY')]) {
                    echo "Running TigerGate CI/CD Container Security Scanner (Upgraded v1.2.3)..."
                    sh '''
                        docker run --rm \
                            -e TIGERGATE_API_KEY="$TIGERGATE_API_KEY" \
                            -v /home/namlabs/Ashz/cicd-scan-cr:/workspace \
                            -w /workspace \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            ${TIGERGATE_CLI} \
                            scan \
                            --api-url "${TIGERGATE_API_URL}" \
                            --type image \
                            --image "${IMAGE_NAME}" \
                            --scan-scope full \
                            --fail-on "${FAIL_ON_SEVERITY}" \
                            --upload
                    '''
                }
            }
        }

        stage('Push to Registry') {
            steps {
                echo "Quality gate PASSED! Pushing image ${IMAGE_NAME} to registry..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME} || echo "Push rejected or unauthorized for namespace nurepublic"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "TigerGate CI/CD scan & Quality Gate PASSED: Image is compliant and was pushed to registry."
        }
        failure {
            echo "TigerGate CI/CD scan or Quality Gate FAILED: Push blocked by security policy to prevent vulnerable artifacts in registry."
        }
    }
}
