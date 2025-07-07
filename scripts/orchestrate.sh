#!/bin/bash

# Orchestration script that can spawn multiple agents
# This script can be called by the triage agent to launch other agents

ACTION=$1
shift  # Remove first argument to get remaining args

case "$ACTION" in
    "architect")
        echo "🏛️  Spawning Architect Agent..."
        claude -p "You are the Architect Agent. First run /architect to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
        ;;
    
    "developer")
        echo "💻 Spawning Developer Agent..."
        claude -p "You are the Developer Agent. First run /developer to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
        ;;
    
    "tester")
        echo "🧪 Spawning Tester Agent..."
        claude -p "You are the Tester Agent. First run /tester to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
        ;;
    
    "reviewer")
        echo "🔍 Spawning Reviewer Agent..."
        claude -p "You are the Reviewer Agent. First run /reviewer to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
        ;;
    
    "documentation")
        echo "📚 Spawning Documentation Agent..."
        claude -p "You are the Documentation Agent. First run /documentation to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
        ;;
    
    "mlops")
        echo "🤖 Spawning MLOps Agent..."
        claude -p "You are the MLOps Agent. First run /mlops to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $*" --verbose
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
        
        # Create initial task on taskboard
        echo "📋 Creating workflow tasks on taskboard..."
        
        # Architecture phase
        echo "1️⃣ Architecture Phase"
        claude -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Design the architecture for $FEATURE" --verbose
        
        # Development phase
        echo "2️⃣ Development Phase"
        claude -p "You are the Developer Agent. First run /developer to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Implement $FEATURE based on the architecture" --verbose
        
        # Testing phase
        echo "3️⃣ Testing Phase"
        claude -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Create comprehensive tests for $FEATURE" --verbose
        
        # Review phase
        echo "4️⃣ Review Phase"
        claude -p "You are the Reviewer Agent. First run /reviewer to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Review the implementation and tests for $FEATURE" --verbose
        
        # Documentation phase
        echo "5️⃣ Documentation Phase"
        claude -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Review all changes and update documentation for $FEATURE" --verbose
        
        echo "✅ Workflow completed for: $FEATURE"
        ;;
    
    "ml-workflow")
        # Execute ML-specific workflow
        MODEL=$1
        echo "🤖 Executing ML workflow for: $MODEL"
        
        # ML Architecture phase
        echo "1️⃣ ML Architecture Phase"
        claude -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard. Then: Design the ML system architecture for $MODEL including data flow, training pipeline, and deployment strategy" --verbose
        
        # MLOps Setup phase
        echo "2️⃣ MLOps Infrastructure Phase"
        claude -p "You are the MLOps Agent. First run /mlops to load your role. Update the taskboard. Then: Set up ML infrastructure for $MODEL including experiment tracking, data versioning, and training pipelines" --verbose
        
        # ML Development phase
        echo "3️⃣ ML Development Phase"
        claude -p "You are the Developer Agent. First run /developer to load your role. Update the taskboard. Then: Implement the model training code and inference API for $MODEL" --verbose
        
        # ML Testing phase
        echo "4️⃣ ML Testing Phase"
        claude -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard. Then: Create model validation tests, performance benchmarks, and edge case tests for $MODEL" --verbose
        
        # Deployment phase
        echo "5️⃣ Model Deployment Phase"
        claude -p "You are the MLOps Agent. First run /mlops to load your role. Update the taskboard. Then: Deploy $MODEL to production with monitoring, scaling, and rollback capabilities" --verbose
        
        # Review phase
        echo "6️⃣ ML Review Phase"
        claude -p "You are the Reviewer Agent. First run /reviewer to load your role. Update the taskboard. Then: Review the ML pipeline, model code, and deployment configuration for $MODEL" --verbose
        
        # Documentation phase
        echo "7️⃣ ML Documentation Phase"
        claude -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard. Then: Create model card, API documentation, and usage guides for $MODEL" --verbose
        
        echo "✅ ML workflow completed for: $MODEL"
        ;;
    
    *)
        echo "Usage: $0 <action> [arguments]"
        echo ""
        echo "Actions:"
        echo "  architect <task>     - Spawn architect agent with task"
        echo "  developer <task>     - Spawn developer agent with task"
        echo "  tester <task>        - Spawn tester agent with task"
        echo "  reviewer <task>      - Spawn reviewer agent with task"
        echo "  documentation <task> - Spawn documentation agent with task"
        echo "  mlops <task>         - Spawn MLOps agent with task"
        echo "  parallel <tasks>     - Run multiple agents in parallel"
        echo "  sequence <tasks>     - Run agents in sequence"
        echo "  workflow <feature>   - Run complete workflow"
        echo "  ml-workflow <model>  - Run ML-specific workflow"
        echo ""
        echo "Examples:"
        echo "  $0 architect 'Design user authentication system'"
        echo "  $0 documentation 'Review and update all documentation'"
        echo "  $0 mlops 'Set up MLflow experiment tracking'"
        echo "  $0 parallel 'architect:design API,developer:setup project structure'"
        echo "  $0 sequence 'architect:design system,developer:implement design'"
        echo "  $0 workflow 'user authentication feature'"
        echo "  $0 ml-workflow 'sentiment analysis model'"
        exit 1
        ;;
esac