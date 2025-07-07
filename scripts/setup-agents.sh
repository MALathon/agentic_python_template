#!/bin/bash

# Setup script for multi-agent Python development environment

echo "Setting up multi-agent Python development environment..."

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Create necessary directories if they don't exist
echo "Creating project directories..."
mkdir -p .claude/commands
mkdir -p .claude/rules
mkdir -p .claude/tasks
mkdir -p src
mkdir -p tests/unit
mkdir -p tests/integration
mkdir -p tests/e2e
mkdir -p docs
mkdir -p scripts

# Make all scripts executable
echo "Making scripts executable..."
chmod +x scripts/*.sh

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed."
    echo "Please install Python 3.8 or later."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate 2>/dev/null || . venv/Scripts/activate 2>/dev/null

# Install basic development dependencies
echo "Installing development dependencies..."
pip install --upgrade pip
pip install pytest pytest-cov pytest-mock
pip install black flake8 mypy isort
pip install pre-commit

# Create requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    echo "Creating requirements.txt..."
    cat > requirements.txt << 'EOF'
# Production dependencies
# Add your project dependencies here

# Development dependencies (install with pip install -r requirements-dev.txt)
EOF
fi

# Create requirements-dev.txt
echo "Creating requirements-dev.txt..."
cat > requirements-dev.txt << 'EOF'
-r requirements.txt

# Testing
pytest>=7.0.0
pytest-cov>=4.0.0
pytest-mock>=3.0.0
pytest-asyncio>=0.21.0

# Code quality
black>=23.0.0
flake8>=6.0.0
mypy>=1.0.0
isort>=5.0.0

# Pre-commit hooks
pre-commit>=3.0.0

# Documentation
sphinx>=6.0.0
sphinx-rtd-theme>=1.0.0
EOF

# Create basic Python package structure
echo "Creating basic package structure..."

# Create src/__init__.py
touch src/__init__.py

# Create a sample module structure
mkdir -p src/models
mkdir -p src/services
mkdir -p src/utils
mkdir -p src/api

# Create __init__.py files
touch src/models/__init__.py
touch src/services/__init__.py
touch src/utils/__init__.py
touch src/api/__init__.py

# Create tests structure
touch tests/__init__.py
touch tests/unit/__init__.py
touch tests/integration/__init__.py
touch tests/e2e/__init__.py

# Create .pre-commit-config.yaml
echo "Setting up pre-commit hooks..."
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ["--profile", "black"]

  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        args: ["--max-line-length=88", "--extend-ignore=E203,W503"]
EOF

# Initialize pre-commit
pre-commit install

# Create a simple conftest.py for pytest
echo "Creating pytest configuration..."
cat > tests/conftest.py << 'EOF'
"""Shared pytest fixtures and configuration."""

import pytest


@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {
        "test": "data",
        "value": 42
    }
EOF

# Create initial task tracking file
echo "Creating initial task tracking..."
cat > .claude/tasks/README.md << 'EOF'
# Task Tracking

This directory contains task tracking information for the multi-agent workflow.

## Active Tasks

Currently no active tasks.

## Completed Tasks

No completed tasks yet.

## Task Format

Tasks are tracked in markdown files with the following format:

```markdown
# Task: [Task ID] - [Task Name]

**Status**: [Not Started/In Progress/Blocked/In Review/Completed]
**Assigned To**: [Agent Name]
**Created**: [Date]
**Updated**: [Date]

## Description
[Task description]

## Progress
- [ ] Subtask 1
- [ ] Subtask 2

## Notes
[Any relevant notes]
```
EOF

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Activate the virtual environment: source venv/bin/activate"
echo "2. Install project dependencies: pip install -r requirements-dev.txt"
echo "3. Start using agents:"
echo "   - Task breakdown: claude code --task 'your task'"
echo "   - Architecture: ./scripts/launch-architect.sh"
echo "   - Development: ./scripts/launch-developer.sh"
echo "   - Testing: ./scripts/launch-tester.sh"
echo "   - Review: ./scripts/launch-reviewer.sh"
echo "   - Triage: ./scripts/launch-triage.sh"
echo ""
echo "Happy coding with multi-agent development!"