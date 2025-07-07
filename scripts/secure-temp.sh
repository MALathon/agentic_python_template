#!/bin/bash

# Secure temporary file creation helper

create_secure_temp() {
    local prefix=${1:-"claude"}
    local suffix=${2:-".log"}
    
    # Create temp file with restricted permissions
    local tempfile=$(mktemp -t "${prefix}-XXXXXX${suffix}")
    chmod 600 "$tempfile"
    
    echo "$tempfile"
}

# Example usage:
# LOGFILE=$(create_secure_temp "agent" ".log")

# Input validation helper
validate_agent_name() {
    local agent=$1
    
    # Only allow alphanumeric and underscore
    if [[ ! "$agent" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Invalid agent name: $agent" >&2
        return 1
    fi
    
    # Check against known agents
    local valid_agents="architect developer tester reviewer documentation mlops devops project product portfolio research ux customer scrum"
    if [[ ! " $valid_agents " =~ " $agent " ]]; then
        echo "Error: Unknown agent: $agent" >&2
        return 1
    fi
    
    return 0
}
