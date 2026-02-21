#!/bin/bash

# Bash script sample for testing syntax highlighting
set -euo pipefail

# Configuration variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/var/log/app.log"
readonly BACKUP_DIR="/backup"
readonly MAX_RETRIES=3

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate input
validate_input() {
    local input="$1"
    local pattern="$2"
    
    if [[ ! "$input" =~ $pattern ]]; then
        log_error "Invalid input: $input"
        return 1
    fi
    return 0
}

# Backup function
create_backup() {
    local source_dir="$1"
    local backup_name="$2"
    
    if [[ ! -d "$source_dir" ]]; then
        log_error "Source directory does not exist: $source_dir"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${BACKUP_DIR}/${backup_name}_${timestamp}.tar.gz"
    
    log_info "Creating backup: $backup_path"
    
    tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
    
    if [[ $? -eq 0 ]]; then
        log_info "Backup created successfully"
        echo "$backup_path"
    else
        log_error "Backup failed"
        return 1
    fi
}

# Process files with retry mechanism
process_files() {
    local file_pattern="$1"
    local retries=0
    
    while [[ $retries -lt $MAX_RETRIES ]]; do
        log_info "Processing files (attempt $((retries + 1))/$MAX_RETRIES)"
        
        for file in $file_pattern; do
            if [[ -f "$file" ]]; then
                log_info "Processing: $file"
                
                # Simulate processing
                if [[ $(basename "$file") =~ \.(log|txt)$ ]]; then
                    grep -v "ERROR" "$file" > "${file}.processed" || true
                    mv "${file}.processed" "$file"
                fi
                
                # Check file size
                local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
                if [[ $size -eq 0 ]]; then
                    log_warn "Empty file: $file"
                fi
            else
                log_warn "File not found: $file"
            fi
        done
        
        # Check if processing was successful
        if [[ $? -eq 0 ]]; then
            log_info "Processing completed successfully"
            return 0
        fi
        
        ((retries++))
        sleep $((retries * 2))
    done
    
    log_error "Processing failed after $MAX_RETRIES attempts"
    return 1
}

# Main function
main() {
    log_info "Starting script execution"
    
    # Check dependencies
    for cmd in tar grep stat; do
        if ! command_exists "$cmd"; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Example usage
    local data_dir="/tmp/data"
    if [[ -d "$data_dir" ]]; then
        local backup_path
        backup_path=$(create_backup "$data_dir" "data_backup")
        
        if [[ -n "$backup_path" ]]; then
            log_info "Backup saved to: $backup_path"
        fi
    fi
    
    # Process log files
    process_files "/tmp/*.log"
    
    log_info "Script execution completed"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
