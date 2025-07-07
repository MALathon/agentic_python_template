#!/bin/bash

# Full Repository Audit Script
# Runs comprehensive audit using all agents in parallel

echo "🎯 FULL REPOSITORY AUDIT"
echo "======================="
echo ""
echo "This script demonstrates parallel agent orchestration for a complete audit."
echo ""

# Use the parallel orchestration script
if [ -x "./scripts/orchestrate-parallel.sh" ]; then
    echo "Mode: Parallel execution (agents run simultaneously)"
    echo ""
    
    # Start the audit
    ./scripts/orchestrate-parallel.sh headless audit
    
    echo ""
    echo "Waiting for agents to complete their analysis..."
    sleep 5
    
    # Show status
    echo ""
    echo "📋 Agent Status:"
    ./scripts/orchestrate-parallel.sh headless monitor
    
    echo ""
    echo "📡 To view real-time logs:"
    echo "   tail -f /tmp/claude-*.log"
    echo ""
    echo "🖥️  To run in iTerm2 windows:"
    echo "   ./scripts/orchestrate-parallel.sh iterm audit"
    echo ""
    echo "🛑 To stop all agents:"
    echo "   ./scripts/orchestrate-parallel.sh headless kill-all"
else
    echo "Error: orchestrate-parallel.sh not found"
    exit 1
fi

echo ""
echo "📋 Full Audit Process:"
echo "1. Architect reviews system design and patterns"
echo "2. Reviewer audits code quality and security"
echo "3. Tester validates test coverage and quality"
echo "4. Documentation checks completeness"
echo "5. DevOps verifies deployment readiness"
echo ""
echo "All agents work in parallel and update the shared taskboard."