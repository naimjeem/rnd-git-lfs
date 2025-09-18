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
                    
                    // Checkout repository from GitHub
                    // Configured for: https://github.com/naimjeem/rnd-git-lfs.git
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/master']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/naimjeem/rnd-git-lfs.git',
                            credentialsId: 'github-credentials' // Optional: remove this line for public repos
                        ]],
                        extensions: [
                            [$class: 'CleanBeforeCheckout'],
                            [$class: 'CloneOption', 
                             depth: 1, 
                             noTags: true, 
                             shallow: true,
                             reference: '',
                             honorRefspec: true]
                        ]
                    ])
                    
                    echo "Repository checked out successfully"
                }
            }
        }
        
        stage('Git LFS Setup') {
            steps {
                script {
                    echo "Setting up Git LFS..."
                    
                    // Check if running on Windows
                    if (isUnix()) {
                        // Unix/Linux/macOS commands
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
                    } else {
                        // Windows commands
                        bat '''
                            echo Checking Git LFS installation...
                            git lfs version >nul 2>&1
                            if %errorlevel% neq 0 (
                                echo Git LFS not found, attempting to install...
                                echo Please ensure Git LFS is installed on this Windows agent
                                echo Download from: https://git-lfs.github.io/
                                echo Or use Chocolatey: choco install git-lfs
                                exit /b 1
                            ) else (
                                echo Git LFS is available
                            )
                        '''
                    }
                    
                    echo "Git LFS setup completed"
                }
            }
        }
        
        stage('Git LFS Pull') {
            steps {
                script {
                    echo "Pulling Git LFS files..."
                    
                    // Initialize Git LFS
                    if (isUnix()) {
                        sh 'git lfs install'
                    } else {
                        bat 'git lfs install'
                    }
                    
                    // Pull LFS files
                    if (isUnix()) {
                        sh 'git lfs pull'
                    } else {
                        bat 'git lfs pull'
                    }
                    
                    echo "Git LFS files pulled successfully"
                }
            }
        }
        
        stage('Verify Files') {
            steps {
                script {
                    echo "Verifying Git LFS files..."
                    
                    // List LFS files
                    if (isUnix()) {
                        sh 'git lfs ls-files'
                    } else {
                        bat 'git lfs ls-files'
                    }
                    
                    // Check file sizes
                    if (isUnix()) {
                        sh '''
                            echo "Checking file sizes:"
                            ls -lh *.bin 2>/dev/null || echo "No .bin files found"
                            echo "Total workspace size:"
                            du -sh .
                        '''
                    } else {
                        bat '''
                            echo Checking file sizes:
                            dir *.bin 2>nul || echo No .bin files found
                            echo Total workspace size:
                            dir /s /-c | find "bytes"
                        '''
                    }
                    
                    echo "File verification completed"
                }
            }
        }
        
        stage('Run Test Script') {
            steps {
                script {
                    echo "Running Git LFS test script..."
                    
                    if (isUnix()) {
                        sh '''
                            if [ -f "test-lfs.sh" ]; then
                                chmod +x test-lfs.sh
                                ./test-lfs.sh
                            else
                                echo "test-lfs.sh not found, skipping test"
                            fi
                        '''
                    } else {
                        bat '''
                            if exist "test-lfs.bat" (
                                call test-lfs.bat
                            ) else (
                                echo test-lfs.bat not found, skipping test
                            )
                        '''
                    }
                    
                    echo "Test script completed"
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
                    if (isUnix()) {
                        sh 'git lfs ls-files > lfs_files.txt'
                    } else {
                        bat 'git lfs ls-files > lfs_files.txt'
                    }
                    archiveArtifacts artifacts: 'lfs_files.txt', allowEmptyArchive: true
                    
                    // Archive test results if available
                    if (isUnix()) {
                        sh 'ls -la > workspace_contents.txt 2>/dev/null || echo "No files found" > workspace_contents.txt'
                    } else {
                        bat 'dir > workspace_contents.txt 2>nul || echo No files found > workspace_contents.txt'
                    }
                    archiveArtifacts artifacts: 'workspace_contents.txt', allowEmptyArchive: true
                    
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
                if (isUnix()) {
                    sh '''
                        echo "=== Final Status ==="
                        echo "Git LFS version:"
                        git lfs version || echo "Git LFS not available"
                        echo "LFS files in repository:"
                        git lfs ls-files || echo "No LFS files found"
                        echo "Workspace contents:"
                        ls -la
                    '''
                } else {
                    bat '''
                        echo === Final Status ===
                        echo Git LFS version:
                        git lfs version || echo Git LFS not available
                        echo LFS files in repository:
                        git lfs ls-files || echo No LFS files found
                        echo Workspace contents:
                        dir
                    '''
                }
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
