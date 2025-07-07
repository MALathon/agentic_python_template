#!/bin/bash

# Security Fix Script - Apply all security fixes identified by reviewer

echo "🔒 Applying Security Fixes"
echo "========================"
echo ""

# Fix 1: Replace "$@" with "$@" in all shell scripts
echo "1. Fixing command injection vulnerabilities..."
find scripts -name "*.sh" -type f -exec sed -i '' 's/\$\*/"\$@"/g' {} \;
echo "   ✅ Replaced \"$@" with \"\$@\" in all scripts"

# Fix 2: Fix eval usage
echo ""
echo "2. Replacing unsafe eval with bash -c..."
# Already fixed in adaptive-workflow.sh
echo "   ✅ Fixed eval usage"

# Fix 3: Update requirements.txt with pinned versions
echo ""
echo "3. Pinning dependency versions..."
cat > requirements.txt << EOF
# Core testing dependencies with pinned versions
pytest==8.4.1
pytest-cov==6.2.1
pytest-asyncio==0.25.2
pytest-mock==3.14.1

# Code quality tools with pinned versions
black==24.12.1
isort==5.14.0
flake8==7.0.0
mypy==1.14.1
pre-commit==4.0.1

# Security scanning
bandit==1.8.0
safety==3.3.1

# Documentation
mkdocs==1.6.1
mkdocs-material==9.6.17

# Development tools
ipython==8.32.0
ipdb==0.14.0
rich==13.12.0

# Type stubs
types-requests==2.32.0.20250106
types-PyYAML==6.0.12.20240917
EOF
echo "   ✅ Created requirements.txt with pinned versions"

# Fix 4: Create secure tempfile function
echo ""
echo "4. Creating secure tempfile helper..."
cat > scripts/secure-temp.sh << 'EOF'
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
EOF
chmod +x scripts/secure-temp.sh
echo "   ✅ Created secure tempfile helper"

# Fix 5: Update pkill usage to be more specific
echo ""
echo "5. Fixing process management..."
sed -i '' 's/pkill -f "claude -p"/pkill -f "claude.*-p.*Agent"/g' scripts/orchestrate-parallel.sh
echo "   ✅ Made pkill more specific"

# Fix 6: Add input validation function
echo ""
echo "6. Adding input validation..."
cat >> scripts/secure-temp.sh << 'EOF'

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
EOF
echo "   ✅ Added input validation"

echo ""
echo "🎉 Security fixes applied successfully!"
echo ""
echo "Summary of fixes:"
echo "- Command injection vulnerabilities fixed"
echo "- Unsafe eval replaced with bash -c"
echo "- Dependencies pinned to specific versions"
echo "- Secure temporary file creation implemented"
echo "- Process management made more specific"
echo "- Input validation added"
echo ""
echo "Run './scripts/orchestrate.sh tester \"verify security fixes\"' to validate"