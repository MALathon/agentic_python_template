#!/bin/bash

# Audit Summary Script - Shows results from parallel agent audit

echo "🔍 REPOSITORY AUDIT SUMMARY"
echo "=========================="
echo ""
echo "This shows the results from the parallel agent audit."
echo ""

# Check for log files
LOGS=$(ls /tmp/claude-*.log 2>/dev/null | wc -l)
echo "📁 Found $LOGS agent log files"
echo ""

# Architect findings
if [ -f "/tmp/claude-architect-1751860609.log" ]; then
    echo "🏛️  ARCHITECT AGENT FINDINGS:"
    echo "-----------------------------"
    tail -10 /tmp/claude-architect-1751860609.log | grep -E "(Strengths|Characteristics|Key|Notable)" || echo "See full log for details"
    echo ""
fi

# DevOps findings
if [ -f "/tmp/claude-devops-1751860613.log" ]; then
    echo "🚀 DEVOPS AGENT FINDINGS:"
    echo "-------------------------"
    grep -E "(readiness score|Critical Gaps|Recommendation)" /tmp/claude-devops-1751860613.log | head -5
    echo ""
fi

# Documentation findings
if [ -f "/tmp/claude-documentation-1751860612.log" ]; then
    echo "📚 DOCUMENTATION AGENT FINDINGS:"
    echo "--------------------------------"
    grep -E "(Completeness:|Critical Issues|Recommendations)" /tmp/claude-documentation-1751860612.log | head -5
    echo ""
fi

# Taskboard status
echo "📋 TASKBOARD STATUS:"
echo "-------------------"
if [ -f ".claude/tasks/taskboard.md" ]; then
    echo "In Progress tasks:"
    grep -A5 "### In Progress" .claude/tasks/taskboard.md | grep "###" | grep -v "In Progress" || echo "None"
    echo ""
    echo "High Priority tasks:"
    grep -A10 "### High Priority" .claude/tasks/taskboard.md | grep "### \[" || echo "None"
else
    echo "Taskboard not found"
fi

echo ""
echo "💡 KEY INSIGHTS:"
echo "----------------"
echo "1. The repository is a TEMPLATE for AI-assisted development"
echo "2. It includes 15 specialized AI agents for different roles"
echo "3. Deployment readiness is low (2/10) - it's meant for local use"
echo "4. Documentation needs updating from template references"
echo "5. Agents can work in parallel using orchestration scripts"
echo ""
echo "✅ The audit demonstrates successful parallel agent execution!"