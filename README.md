# Git LFS Demo Repository

This repository demonstrates Git LFS (Large File Storage) functionality with a 500MB test file and includes a Jenkins pipeline for automated checkout and pull operations.

## Repository Contents

- `large_file.bin` - A 500MB binary file tracked by Git LFS
- `.gitattributes` - Git LFS configuration file
- `Jenkinsfile` - Jenkins pipeline configuration
- `README.md` - This documentation

## Prerequisites

### Local Development
- Git 2.0 or later
- Git LFS 2.0 or later

### Jenkins Setup
- Jenkins 2.0 or later
- Git plugin for Jenkins
- Pipeline plugin for Jenkins
- Git LFS installed on Jenkins agents

## Local Setup Instructions

### 1. Install Git LFS

**Windows:**
```bash
# Using Chocolatey
choco install git-lfs

# Or download from https://git-lfs.github.io/
```

**macOS:**
```bash
brew install git-lfs
```

**Linux (Ubuntu/Debian):**
```bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
```

**Linux (CentOS/RHEL):**
```bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
sudo yum install git-lfs
```

### 2. Clone and Setup Repository

```bash
# Clone the repository
git clone <repository-url>
cd git-lfs

# Initialize Git LFS
git lfs install

# Pull LFS files
git lfs pull
```

### 3. Verify Setup

```bash
# Check LFS files
git lfs ls-files

# Verify file size
ls -lh large_file.bin
```

## Jenkins Pipeline Setup

### 1. Prerequisites

Ensure your Jenkins environment has:
- Git LFS installed on all agents
- Sufficient disk space for large files
- Network access to Git LFS server

### 2. Pipeline Configuration

The `Jenkinsfile` includes the following stages:

1. **Checkout** - Clones the repository
2. **Git LFS Pull** - Downloads LFS files
3. **Verify Files** - Confirms file integrity
4. **Archive Artifacts** - Stores files for later use

### 3. Key Features

- **Automatic Git LFS Installation**: Pipeline installs Git LFS if not available
- **Cross-Platform Support**: Works on Ubuntu, CentOS, and macOS
- **Error Handling**: Comprehensive error checking and reporting
- **Artifact Archiving**: Saves LFS files for downstream jobs

### 4. Environment Variables

The pipeline uses:
- `GIT_LFS_SKIP_SMUDGE=1` - Prevents automatic LFS file download during checkout

### 5. Running the Pipeline

1. Create a new Jenkins job
2. Select "Pipeline" as the job type
3. Configure the pipeline to use the `Jenkinsfile` from this repository
4. Run the job

## Git LFS Configuration

### .gitattributes
```
*.bin filter=lfs diff=lfs merge=lfs -text
```

This configuration:
- Tracks all `.bin` files with Git LFS
- Uses LFS for diff and merge operations
- Treats files as binary (not text)

## Troubleshooting

### Common Issues

1. **Git LFS not installed**
   - Solution: Install Git LFS on your system or Jenkins agent

2. **Large file not tracked by LFS**
   - Solution: Ensure `.gitattributes` is committed before adding large files

3. **Jenkins pipeline fails on LFS pull**
   - Solution: Check network connectivity and LFS server access

4. **Disk space issues**
   - Solution: Ensure sufficient disk space for LFS files

### Verification Commands

```bash
# Check Git LFS status
git lfs status

# List LFS files
git lfs ls-files

# Check LFS configuration
git lfs env

# Verify file tracking
git lfs track
```

## File Information

- **File**: `large_file.bin`
- **Size**: 500MB (524,288,000 bytes)
- **Type**: Binary file filled with zeros
- **LFS Pointer**: `a08a92258f`

## Performance Considerations

- **Clone Time**: Initial clone is fast (only downloads LFS pointers)
- **Pull Time**: `git lfs pull` downloads actual file content
- **Storage**: LFS files are stored separately from Git repository
- **Bandwidth**: Only downloads files when needed

## Security Notes

- LFS files are stored on the LFS server, not in the Git repository
- Ensure proper authentication for LFS server access
- Consider LFS server security and backup strategies

## Support

For issues with:
- **Git LFS**: Check [Git LFS documentation](https://git-lfs.github.io/)
- **Jenkins**: Check [Jenkins documentation](https://jenkins.io/doc/)
- **This Demo**: Create an issue in this repository
