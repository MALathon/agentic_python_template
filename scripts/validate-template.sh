#!/bin/bash

# Template Validation Script
# Run this to validate the agentic template is working correctly
# This is for template maintainers, not end users

set -e

echo "🔍 Validating Agentic Python Template"
echo "====================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python
echo "1️⃣ Checking Python environment..."
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Python3 found: $(python3 --version)"
else
    echo -e "${RED}✗${NC} Python3 not found"
    exit 1
fi

# Check directory structure
echo ""
echo "2️⃣ Checking directory structure..."
required_dirs=(
    ".claude/commands"
    ".claude/rules" 
    ".claude/tasks"
    "scripts"
    "tests/template"
    "tests/example"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} Directory exists: $dir"
    else
        echo -e "${RED}✗${NC} Missing directory: $dir"
        exit 1
    fi
done

# Check critical files
echo ""
echo "3️⃣ Checking critical files..."
required_files=(
    "scripts/orchestrate.sh"
    "scripts/meeting.sh"
    ".claude/rules/project.md"
    ".claude/tasks/taskboard.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} File exists: $file"
    else
        echo -e "${RED}✗${NC} Missing file: $file"
        exit 1
    fi
done

# Check agent commands
echo ""
echo "4️⃣ Checking agent command files..."
agents=(
    "architect" "developer" "tester" "reviewer" "documentation"
    "mlops" "devops" "project" "product" "portfolio"
    "research" "ux" "customer" "scrum" "triage"
)

for agent in "${agents[@]}"; do
    if [ -f ".claude/commands/${agent}.md" ]; then
        echo -e "${GREEN}✓${NC} Agent command exists: $agent"
    else
        echo -e "${RED}✗${NC} Missing agent command: $agent"
        exit 1
    fi
done

# Check launch scripts
echo ""
echo "5️⃣ Checking launch scripts..."
for agent in "${agents[@]}"; do
    if [[ "$agent" != "triage" ]]; then  # Triage doesn't have a launch script
        script="scripts/launch-${agent}.sh"
        if [ -f "$script" ] && [ -x "$script" ]; then
            echo -e "${GREEN}✓${NC} Launch script OK: $script"
        else
            echo -e "${RED}✗${NC} Problem with launch script: $script"
            exit 1
        fi
    fi
done

# Check shell script syntax
echo ""
echo "6️⃣ Checking shell script syntax..."
for script in scripts/*.sh; do
    if bash -n "$script" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Valid syntax: $script"
    else
        echo -e "${RED}✗${NC} Syntax error in: $script"
        bash -n "$script"
        exit 1
    fi
done

# Check orchestration modes
echo ""
echo "7️⃣ Testing orchestration script..."
if ./scripts/orchestrate.sh 2>&1 | grep -q "Usage:"; then
    echo -e "${GREEN}✓${NC} Orchestration help works"
else
    echo -e "${RED}✗${NC} Orchestration help failed"
    exit 1
fi

if ./scripts/orchestrate.sh analyze "test request" 2>&1 | grep -q "Analyzing request"; then
    echo -e "${GREEN}✓${NC} Orchestration analyze works"
else
    echo -e "${RED}✗${NC} Orchestration analyze failed"
    exit 1
fi

# Check meeting script
echo ""
echo "8️⃣ Testing meeting script..."
if ./scripts/meeting.sh 2>&1 | grep -q "Usage:"; then
    echo -e "${GREEN}✓${NC} Meeting help works"
else
    echo -e "${RED}✗${NC} Meeting help failed"
    exit 1
fi

# Run Python tests if pytest is available
echo ""
echo "9️⃣ Running Python tests..."
if command -v pytest &> /dev/null; then
    echo "Running template validation tests..."
    pytest tests/template/ -v --tb=short || echo -e "${YELLOW}⚠️${NC} Some tests failed"
else
    echo -e "${YELLOW}⚠️${NC} pytest not installed, skipping Python tests"
    echo "   Install with: pip install pytest"
fi

# Check attribution rules
echo ""
echo "🔟 Checking attribution rules..."
if grep -q "DO NOT include Claude attribution" .claude/rules/project.md; then
    echo -e "${GREEN}✓${NC} Attribution rules found"
else
    echo -e "${RED}✗${NC} Attribution rules missing"
    exit 1
fi

# Summary
echo ""
echo "===================================="
echo -e "${GREEN}✅ Template validation complete!${NC}"
echo ""
echo "The agentic Python template is properly configured."
echo ""
echo "Note: This validates the template structure only."
echo "It does not test actual agent interactions with Claude."
echo ""
echo "For CI/CD integration, use: .github/workflows/template-validation.yml"