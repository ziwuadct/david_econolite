pipeline {
    agent any

    stages {
        stage('Initialize') {
            steps {
                echo 'Starting Econolite Build...'
                powershell 'docker version'
            }
        }
        
        
        stage('Checkout Source') {
            steps {
                // This pulls the code from your GitHub repo using the token
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/ziwuadct/david_econolite.git', 
                        credentialsId: 'econolite-github-token' // Must match the ID from Step 1
                    ]]
                ])
            }
        }   
        
        
        
        stage('build docker') {
            parallel {
                stage('Build Docker Image linux') {
                    steps {
                        // This builds your main Dockerfile
                        powershell 'docker build -t c-gcc-demo:linux --build-arg GIT_VERSION=$(git describe --tags --dirty --always) .'
                    }
                }
                
                stage('Build Docker Image release') {
                    steps {
                        // This builds your main Dockerfile
                        powershell 'docker build -t c-gcc-demo:release --build-arg RELEASE=true --build-arg GIT_VERSION=$(git describe --tags --dirty --always) .'
                    }
                }
                
                stage('Health Check') {
                    steps {
                        echo "Checking system status while building..."
                        powershell 'docker version'
                    }
                }
            }
        }
        

        
        stage('Verify') {
            steps {
                powershell 'docker images | findstr c-gcc-demo'
            }
        }
        
        stage('run linux') {
            steps {
                powershell 'docker run --rm c-gcc-demo:linux This is a test'
            }
        }
        
        stage('run release') {
            steps {
                powershell 'docker run --rm c-gcc-demo:release This is a test'
            }
        }
        
        stage('Deploy Artifact') {
            steps {
                // Use sshUserPrivateKey - this is built into Jenkins and very stable
                withCredentials([sshUserPrivateKey(credentialsId: 'econolte_labadmin_scp', 
                                                  keyFileVariable: 'SSH_KEY')]) {
                    powershell """
                        # -i points to the temporary key file Jenkins created
                        # -o StrictHostKeyChecking=no prevents the "trust this host" prompt
                        scp -i "\$env:SSH_KEY" -o StrictHostKeyChecking=no "C:\\temp\\app" "labadmin@192.168.86.229:C:\\wipro\\appp"
                    """
                }
            }
        }

               
        stage('Deploy PPC Binary') {
            steps {
            
                powershell '''
                if (docker ps -a --format '{{.Names}}' | findstr "tmp_app") 
                {
                    docker rm -f tmp_app
                }
                '''
                
                powershell 'docker create --name tmp_app c-gcc-demo:release'
                powershell 'docker cp tmp_app:/app/repos/app c:/temp'
                
                powershell 'pscp -batch -hostkey "SHA256:MremSl0rKC8Ae92G8DNXIvGVEVGPuaaeDn52/W21bUo" -pw MyLabPass123! c:\\temp\\app labadmin@192.168.86.229:C:\\wipro\\'
            }
        }





    }
}