pipeline {
    agent any
    
    environment {
        // Set Git LFS configuration
        GIT_LFS_SKIP_SMUDGE = '1'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Starting Git LFS checkout process..."
                    
                    // Clean workspace
                    cleanWs()
                    
                    // Checkout repository
                    checkout scm
                    
                    echo "Repository checked out successfully"
                }
            }
        }
        
        stage('Git LFS Pull') {
            steps {
                script {
                    echo "Pulling Git LFS files..."
                    
                    // Install Git LFS if not available
                    sh '''
                        if ! command -v git-lfs &> /dev/null; then
                            echo "Git LFS not found, installing..."
                            # For Ubuntu/Debian
                            if command -v apt-get &> /dev/null; then
                                curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
                                sudo apt-get install git-lfs -y
                            # For CentOS/RHEL
                            elif command -v yum &> /dev/null; then
                                curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
                                sudo yum install git-lfs -y
                            # For macOS
                            elif command -v brew &> /dev/null; then
                                brew install git-lfs
                            else
                                echo "Cannot install Git LFS automatically. Please install manually."
                                exit 1
                            fi
                        fi
                    '''
                    
                    // Initialize Git LFS
                    sh 'git lfs install'
                    
                    // Pull LFS files
                    sh 'git lfs pull'
                    
                    echo "Git LFS files pulled successfully"
                }
            }
        }
        
        stage('Verify Files') {
            steps {
                script {
                    echo "Verifying Git LFS files..."
                    
                    // List LFS files
                    sh 'git lfs ls-files'
                    
                    // Check file sizes
                    sh '''
                        echo "Checking file sizes:"
                        ls -lh *.bin 2>/dev/null || echo "No .bin files found"
                        echo "Total workspace size:"
                        du -sh .
                    '''
                    
                    echo "File verification completed"
                }
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                script {
                    echo "Archiving artifacts..."
                    
                    // Archive the large file
                    archiveArtifacts artifacts: '*.bin', allowEmptyArchive: true
                    
                    // Archive Git LFS status
                    sh 'git lfs ls-files > lfs_files.txt'
                    archiveArtifacts artifacts: 'lfs_files.txt', allowEmptyArchive: true
                    
                    echo "Artifacts archived successfully"
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "Pipeline completed. Cleaning up..."
                
                // Display final status
                sh '''
                    echo "=== Final Status ==="
                    echo "Git LFS version:"
                    git lfs version || echo "Git LFS not available"
                    echo "LFS files in repository:"
                    git lfs ls-files || echo "No LFS files found"
                    echo "Workspace contents:"
                    ls -la
                '''
            }
        }
        
        success {
            echo "Pipeline succeeded! Git LFS checkout and pull completed successfully."
        }
        
        failure {
            echo "Pipeline failed! Check the logs for details."
        }
    }
}
