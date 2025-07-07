#!/bin/bash

# Orchestration script that can spawn multiple agents
# This script can be called by the triage agent to launch other agents

ACTION=$1
shift  # Remove first argument to get remaining args

case "$ACTION" in
    "architect")
        echo "🏛️  Spawning Architect Agent..."
        claude -p "You are the Architect Agent. First run /architect to load your role, then: $*" --verbose
        ;;
    
    "developer")
        echo "💻 Spawning Developer Agent..."
        claude -p "You are the Developer Agent. First run /developer to load your role, then: $*" --verbose
        ;;
    
    "tester")
        echo "🧪 Spawning Tester Agent..."
        claude -p "You are the Tester Agent. First run /tester to load your role, then: $*" --verbose
        ;;
    
    "reviewer")
        echo "🔍 Spawning Reviewer Agent..."
        claude -p "You are the Reviewer Agent. First run /reviewer to load your role, then: $*" --verbose
        ;;
    
    "parallel")
        # Launch multiple agents in parallel
        echo "🚀 Launching agents in parallel..."
        
        # Parse parallel tasks: agent1:task1,agent2:task2
        IFS=',' read -ra TASKS <<< "$1"
        
        for task in "${TASKS[@]}"; do
            IFS=':' read -r agent task_desc <<< "$task"
            echo "Starting $agent for: $task_desc"
            claude -p "You are the ${agent^} Agent. First run /$agent to load your role, then: $task_desc" --verbose &
        done
        
        wait  # Wait for all background processes
        echo "✅ All parallel tasks completed"
        ;;
    
    "sequence")
        # Launch agents in sequence with dependencies
        echo "📋 Launching agents in sequence..."
        
        # Parse sequence: architect:design system,developer:implement based on architecture
        IFS=',' read -ra TASKS <<< "$1"
        
        for task in "${TASKS[@]}"; do
            IFS=':' read -r agent task_desc <<< "$task"
            echo "▶️  Starting $agent for: $task_desc"
            claude -p "You are the ${agent^} Agent. First run /$agent to load your role, then: $task_desc" --verbose
            
            if [ $? -ne 0 ]; then
                echo "❌ $agent failed, stopping sequence"
                exit 1
            fi
            echo "✅ $agent completed"
        done
        
        echo "✅ Sequence completed successfully"
        ;;
    
    "workflow")
        # Execute a complete workflow
        FEATURE=$1
        echo "🔄 Executing complete workflow for: $FEATURE"
        
        # Architecture phase
        echo "1️⃣ Architecture Phase"
        claude -p "You are the Architect Agent. First run /architect to load your role, then: Design the architecture for $FEATURE" --verbose
        
        # Development phase
        echo "2️⃣ Development Phase"
        claude -p "You are the Developer Agent. First run /developer to load your role, then: Implement $FEATURE based on the architecture" --verbose
        
        # Testing phase
        echo "3️⃣ Testing Phase"
        claude -p "You are the Tester Agent. First run /tester to load your role, then: Create comprehensive tests for $FEATURE" --verbose
        
        # Review phase
        echo "4️⃣ Review Phase"
        claude -p "You are the Reviewer Agent. First run /reviewer to load your role, then: Review the implementation and tests for $FEATURE" --verbose
        
        echo "✅ Workflow completed for: $FEATURE"
        ;;
    
    *)
        echo "Usage: $0 <action> [arguments]"
        echo ""
        echo "Actions:"
        echo "  architect <task>     - Spawn architect agent with task"
        echo "  developer <task>     - Spawn developer agent with task"
        echo "  tester <task>        - Spawn tester agent with task"
        echo "  reviewer <task>      - Spawn reviewer agent with task"
        echo "  parallel <tasks>     - Run multiple agents in parallel"
        echo "  sequence <tasks>     - Run agents in sequence"
        echo "  workflow <feature>   - Run complete workflow"
        echo ""
        echo "Examples:"
        echo "  $0 architect 'Design user authentication system'"
        echo "  $0 parallel 'architect:design API,developer:setup project structure'"
        echo "  $0 sequence 'architect:design system,developer:implement design'"
        echo "  $0 workflow 'user authentication feature'"
        exit 1
        ;;
esac