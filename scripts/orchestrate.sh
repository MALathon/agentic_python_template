#!/bin/bash

# Orchestration script that can spawn multiple agents
# This script can be called by the triage agent to launch other agents

# Find claude command
if command -v claude &> /dev/null; then
    CLAUDE_CMD="claude"
elif [ -x "${HOME}/.claude/local/claude" ]; then
    CLAUDE_CMD="${HOME}/.claude/local/claude"
else
    echo "Error: Claude CLI not found. Please install Claude Code."
    exit 1
fi

ACTION=$1
shift  # Remove first argument to get remaining args

case "$ACTION" in
    "architect")
        echo "🏛️  Spawning Architect Agent..."
        $CLAUDE_CMD -p "You are the Architect Agent. First run /architect to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "developer")
        echo "💻 Spawning Developer Agent..."
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "tester")
        echo "🧪 Spawning Tester Agent..."
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "reviewer")
        echo "🔍 Spawning Reviewer Agent..."
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "documentation")
        echo "📚 Spawning Documentation Agent..."
        $CLAUDE_CMD -p "You are the Documentation Agent. First run /documentation to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "mlops")
        echo "🤖 Spawning MLOps Agent..."
        $CLAUDE_CMD -p "You are the MLOps Agent. First run /mlops to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "devops")
        echo "🚀 Spawning DevOps Agent..."
        $CLAUDE_CMD -p "You are the DevOps Agent. First run /devops to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "project")
        echo "📋 Spawning Project Manager Agent..."
        $CLAUDE_CMD -p "You are the Project Manager Agent. First run /project to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "product")
        echo "📦 Spawning Product Manager Agent..."
        $CLAUDE_CMD -p "You are the Product Manager Agent. First run /product to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "portfolio")
        echo "📊 Spawning Portfolio Manager Agent..."
        $CLAUDE_CMD -p "You are the Portfolio Manager Agent. First run /portfolio to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "research")
        echo "🔬 Spawning Research Team Agent..."
        $CLAUDE_CMD -p "You are the Research Team Agent. First run /research to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "ux")
        echo "🎨 Spawning UX Agent..."
        $CLAUDE_CMD -p "You are the UX Agent. First run /ux to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "customer")
        echo "👥 Spawning Customer Voice Agent..."
        $CLAUDE_CMD -p "You are the Customer Voice Agent. First run /customer to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "scrum")
        echo "🏃 Spawning Scrum Master Agent..."
        $CLAUDE_CMD -p "You are the Scrum Master Agent. First run /scrum to load your role. IMPORTANT: Update the taskboard at .claude/tasks/taskboard.md to show your task status. Then complete: $@" --verbose
        ;;
    
    "parallel")
        # Launch multiple agents in parallel
        echo "🚀 Launching agents in parallel..."
        
        # Parse parallel tasks: agent1:task1,agent2:task2
        IFS=',' read -ra TASKS <<< "$1"
        
        for task in "${TASKS[@]}"; do
            IFS=':' read -r agent task_desc <<< "$task"
            echo "Starting $agent for: $task_desc"
            agent_name=$(echo "$agent" | sed 's/^./\U&/')
            $CLAUDE_CMD -p "You are the $agent_name Agent. First run /$agent to load your role, then: $task_desc" --verbose &
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
            $CLAUDE_CMD -p "You are the ${agent^} Agent. First run /$agent to load your role, then: $task_desc" --verbose
            
            if [ $? -ne 0 ]; then
                echo "❌ $agent failed, stopping sequence"
                exit 1
            fi
            echo "✅ $agent completed"
        done
        
        echo "✅ Sequence completed successfully"
        ;;
    
    "workflow")
        # Execute a complete workflow with quality gates
        FEATURE=$1
        echo "🔄 Executing complete workflow with quality gates for: $FEATURE"
        
        # Create initial task on taskboard
        echo "📋 Creating workflow tasks on taskboard..."
        
        # Architecture phase
        echo "1️⃣ Architecture Phase"
        $CLAUDE_CMD -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Design the architecture for $FEATURE" --verbose
        
        # QUALITY GATE: Architecture Review
        echo "🔍 Quality Gate: Architecture Review"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Then: Review the architecture design for $FEATURE and identify any issues" --verbose
        
        # Test Planning (parallel with development)
        echo "2️⃣ Test Planning Phase (parallel)"
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard. Then: Create test plan and test cases for $FEATURE based on architecture" --verbose &
        
        # Development phase
        echo "3️⃣ Development Phase"
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Implement $FEATURE based on the architecture" --verbose
        
        wait # Wait for test planning to complete
        
        # QUALITY GATE: Code Review Round 1
        echo "🔍 Quality Gate: Initial Code Review"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Then: Review the implementation for code quality, patterns, and potential issues in $FEATURE" --verbose
        
        # Testing phase
        echo "4️⃣ Testing Phase"
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Execute comprehensive tests for $FEATURE" --verbose
        
        # QUALITY GATE: Test Results Review
        echo "🔍 Quality Gate: Test Results Review"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Then: Review test results and coverage for $FEATURE" --verbose
        
        # Fix any issues found
        echo "5️⃣ Issue Resolution Phase"
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. Then: Fix any issues identified by tests and reviews for $FEATURE" --verbose
        
        # Final Review phase
        echo "6️⃣ Final Review Phase"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Perform final review including security and performance for $FEATURE" --verbose
        
        # Documentation phase
        echo "7️⃣ Documentation Phase"
        $CLAUDE_CMD -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard at .claude/tasks/taskboard.md. Then: Review all changes and update documentation for $FEATURE" --verbose
        
        # QUALITY GATE: Documentation Review
        echo "🔍 Quality Gate: Documentation Review"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Then: Verify documentation is complete and accurate for $FEATURE" --verbose
        
        echo "✅ Workflow completed with all quality gates for: $FEATURE"
        ;;
    
    "ml-workflow")
        # Execute ML-specific workflow
        MODEL=$1
        echo "🤖 Executing ML workflow for: $MODEL"
        
        # ML Architecture phase
        echo "1️⃣ ML Architecture Phase"
        $CLAUDE_CMD -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard. Then: Design the ML system architecture for $MODEL including data flow, training pipeline, and deployment strategy" --verbose
        
        # MLOps Setup phase
        echo "2️⃣ MLOps Infrastructure Phase"
        $CLAUDE_CMD -p "You are the MLOps Agent. First run /mlops to load your role. Update the taskboard. Then: Set up ML infrastructure for $MODEL including experiment tracking, data versioning, and training pipelines" --verbose
        
        # ML Development phase
        echo "3️⃣ ML Development Phase"
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. Update the taskboard. Then: Implement the model training code and inference API for $MODEL" --verbose
        
        # ML Testing phase
        echo "4️⃣ ML Testing Phase"
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard. Then: Create model validation tests, performance benchmarks, and edge case tests for $MODEL" --verbose
        
        # Deployment phase
        echo "5️⃣ Model Deployment Phase"
        $CLAUDE_CMD -p "You are the MLOps Agent. First run /mlops to load your role. Update the taskboard. Then: Deploy $MODEL to production with monitoring, scaling, and rollback capabilities" --verbose
        
        # Review phase
        echo "6️⃣ ML Review Phase"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Update the taskboard. Then: Review the ML pipeline, model code, and deployment configuration for $MODEL" --verbose
        
        # Documentation phase
        echo "7️⃣ ML Documentation Phase"
        $CLAUDE_CMD -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard. Then: Create model card, API documentation, and usage guides for $MODEL" --verbose
        
        echo "✅ ML workflow completed for: $MODEL"
        ;;
    
    "analyze")
        # Analyze request and suggest agent combination
        REQUEST="$@"
        echo "🔍 Analyzing request: $REQUEST"
        echo ""
        echo "Suggested agent orchestration:"
        
        # Always include reviewer for quality
        echo "- Reviewer Agent: For continuous quality checks (ALWAYS)"
        
        # Keywords for agent selection
        if [[ $REQUEST == *"deploy"* ]] || [[ $REQUEST == *"CI/CD"* ]] || [[ $REQUEST == *"Docker"* ]]; then
            echo "- DevOps Agent: For deployment and infrastructure"
        fi
        
        if [[ $REQUEST == *"API"* ]] || [[ $REQUEST == *"design"* ]] || [[ $REQUEST == *"architect"* ]]; then
            echo "- Architect Agent: For system design"
        fi
        
        if [[ $REQUEST == *"implement"* ]] || [[ $REQUEST == *"code"* ]] || [[ $REQUEST == *"feature"* ]]; then
            echo "- Developer Agent: For implementation"
        fi
        
        if [[ $REQUEST == *"test"* ]] || [[ $REQUEST == *"quality"* ]] || [[ $REQUEST == *"validate"* ]]; then
            echo "- Tester Agent: For quality assurance"
        fi
        
        if [[ $REQUEST == *"model"* ]] || [[ $REQUEST == *"ML"* ]] || [[ $REQUEST == *"training"* ]]; then
            echo "- MLOps Agent: For ML operations"
        fi
        
        if [[ $REQUEST == *"document"* ]] || [[ $REQUEST == *"docs"* ]] || [[ $REQUEST == *"guide"* ]]; then
            echo "- Documentation Agent: For documentation"
        fi
        
        echo ""
        echo "Recommended workflow:"
        echo "1. Initial design/planning"
        echo "2. Review checkpoint"
        echo "3. Implementation"
        echo "4. Testing & review"
        echo "5. Fix issues"
        echo "6. Final review"
        echo "7. Documentation"
        echo ""
        echo "Use 'adaptive' workflow for dynamic adjustment based on reviews"
        echo "Use 'custom' command for specific orchestration"
        ;;
    
    "custom")
        # Execute custom agent combination
        # Format: ./orchestrate.sh custom "architect:design API,devops:setup deployment,developer:implement API"
        TASKS=$1
        echo "🎯 Executing custom agent orchestration"
        echo "Tasks: $TASKS"
        
        IFS=',' read -ra TASK_LIST <<< "$TASKS"
        
        for task in "${TASK_LIST[@]}"; do
            IFS=':' read -r agent task_desc <<< "$task"
            echo ""
            echo "▶️  Spawning $agent for: $task_desc"
            
            case $agent in
                "architect"|"developer"|"tester"|"reviewer"|"documentation"|"mlops"|"devops"|"project"|"product"|"portfolio"|"research"|"ux"|"customer"|"scrum")
                    # Capitalize agent name properly
                    agent_name=$(echo "$agent" | sed 's/^./\U&/')
                    $CLAUDE_CMD -p "You are the $agent_name Agent. First run /$agent to load your role. Update the taskboard. Then: $task_desc" --verbose
                    ;;
                *)
                    echo "Unknown agent: $agent"
                    ;;
            esac
        done
        
        echo ""
        echo "✅ Custom orchestration completed"
        ;;
    
    "deployment-workflow")
        # Complete deployment workflow
        APP=$1
        echo "🚀 Executing deployment workflow for: $APP"
        
        # Architecture review
        echo "1️⃣ Architecture Review"
        $CLAUDE_CMD -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard. Then: Review deployment architecture for $APP" --verbose
        
        # DevOps setup
        echo "2️⃣ DevOps Infrastructure"
        $CLAUDE_CMD -p "You are the DevOps Agent. First run /devops to load your role. Update the taskboard. Then: Set up CI/CD pipeline and containerization for $APP" --verbose
        
        # Testing setup
        echo "3️⃣ Test Automation"
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard. Then: Create deployment tests and smoke tests for $APP" --verbose
        
        # Deployment
        echo "4️⃣ Deployment Execution"
        $CLAUDE_CMD -p "You are the DevOps Agent. First run /devops to load your role. Update the taskboard. Then: Deploy $APP to production with monitoring" --verbose
        
        # Documentation
        echo "5️⃣ Deployment Documentation"
        $CLAUDE_CMD -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard. Then: Create deployment guide and runbook for $APP" --verbose
        
        echo "✅ Deployment workflow completed for: $APP"
        ;;
    
    "product-workflow")
        # Complete product development workflow
        PRODUCT=$1
        echo "📦 Executing product development workflow for: $PRODUCT"
        
        # Product strategy phase
        echo "1️⃣ Product Strategy & Research"
        $CLAUDE_CMD -p "You are the Product Manager Agent. First run /product to load your role. Update the taskboard. Then: Define product vision and roadmap for $PRODUCT" --verbose
        $CLAUDE_CMD -p "You are the Research Team Agent. First run /research to load your role. Update the taskboard. Then: Research market and competitive landscape for $PRODUCT" --verbose
        
        # User research phase
        echo "2️⃣ User Research & Design"
        $CLAUDE_CMD -p "You are the Customer Voice Agent. First run /customer to load your role. Update the taskboard. Then: Gather user requirements and feedback for $PRODUCT" --verbose
        $CLAUDE_CMD -p "You are the UX Agent. First run /ux to load your role. Update the taskboard. Then: Create user research insights and initial designs for $PRODUCT" --verbose
        
        # Development planning
        echo "3️⃣ Development Planning"
        $CLAUDE_CMD -p "You are the Project Manager Agent. First run /project to load your role. Update the taskboard. Then: Create project plan and timeline for $PRODUCT" --verbose
        $CLAUDE_CMD -p "You are the Architect Agent. First run /architect to load your role. Update the taskboard. Then: Design technical architecture for $PRODUCT" --verbose
        
        # Implementation
        echo "4️⃣ Implementation & Testing"
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. Update the taskboard. Then: Implement core features of $PRODUCT" --verbose
        $CLAUDE_CMD -p "You are the Tester Agent. First run /tester to load your role. Update the taskboard. Then: Create comprehensive test suite for $PRODUCT" --verbose
        
        # Review & Quality Gate
        echo "5️⃣ Product Review & Quality Gate"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Update the taskboard. Then: Review all aspects of $PRODUCT including code, UX, and product-market fit" --verbose
        
        # Fix any issues found in review
        echo "6️⃣ Issue Resolution"
        $CLAUDE_CMD -p "You are the Developer Agent. First run /developer to load your role. Then: Address any issues found in the product review for $PRODUCT" --verbose
        
        # Deployment & Launch
        echo "7️⃣ Deployment & Launch"
        $CLAUDE_CMD -p "You are the DevOps Agent. First run /devops to load your role. Update the taskboard. Then: Deploy $PRODUCT to production" --verbose
        
        # Final Review
        echo "8️⃣ Final Review & Documentation"
        $CLAUDE_CMD -p "You are the Reviewer Agent. First run /reviewer to load your role. Then: Perform final production readiness review for $PRODUCT" --verbose
        $CLAUDE_CMD -p "You are the Documentation Agent. First run /documentation to load your role. Update the taskboard. Then: Create user and technical documentation for $PRODUCT" --verbose
        
        echo "✅ Product development workflow completed for: $PRODUCT"
        ;;
    
    "analyze")
        # Analyze request and suggest agent combination
        REQUEST="$@"
        echo "🔍 Analyzing request: $REQUEST"
        echo ""
        echo "Suggested agent orchestration:"
        
        # Keywords for agent selection
        if [[ $REQUEST == *"product"* ]] || [[ $REQUEST == *"feature"* ]] || [[ $REQUEST == *"roadmap"* ]]; then
            echo "- Product Manager: For product strategy and requirements"
        fi
        
        if [[ $REQUEST == *"project"* ]] || [[ $REQUEST == *"timeline"* ]] || [[ $REQUEST == *"resources"* ]]; then
            echo "- Project Manager: For planning and coordination"
        fi
        
        if [[ $REQUEST == *"portfolio"* ]] || [[ $REQUEST == *"multiple"* ]] || [[ $REQUEST == *"investment"* ]]; then
            echo "- Portfolio Manager: For multi-project oversight"
        fi
        
        if [[ $REQUEST == *"research"* ]] || [[ $REQUEST == *"competitor"* ]] || [[ $REQUEST == *"market"* ]]; then
            echo "- Research Team: For analysis and insights"
        fi
        
        if [[ $REQUEST == *"user"* ]] || [[ $REQUEST == *"customer"* ]] || [[ $REQUEST == *"feedback"* ]]; then
            echo "- Customer Voice: For user perspective"
        fi
        
        if [[ $REQUEST == *"design"* ]] || [[ $REQUEST == *"UX"* ]] || [[ $REQUEST == *"interface"* ]]; then
            echo "- UX Agent: For design and usability"
        fi
        
        if [[ $REQUEST == *"deploy"* ]] || [[ $REQUEST == *"CI/CD"* ]] || [[ $REQUEST == *"Docker"* ]]; then
            echo "- DevOps Agent: For deployment and infrastructure"
        fi
        
        if [[ $REQUEST == *"API"* ]] || [[ $REQUEST == *"architect"* ]] || [[ $REQUEST == *"system"* ]]; then
            echo "- Architect Agent: For system design"
        fi
        
        if [[ $REQUEST == *"implement"* ]] || [[ $REQUEST == *"code"* ]] || [[ $REQUEST == *"develop"* ]]; then
            echo "- Developer Agent: For implementation"
        fi
        
        if [[ $REQUEST == *"test"* ]] || [[ $REQUEST == *"quality"* ]] || [[ $REQUEST == *"validate"* ]]; then
            echo "- Tester Agent: For quality assurance"
        fi
        
        if [[ $REQUEST == *"model"* ]] || [[ $REQUEST == *"ML"* ]] || [[ $REQUEST == *"training"* ]]; then
            echo "- MLOps Agent: For ML operations"
        fi
        
        if [[ $REQUEST == *"document"* ]] || [[ $REQUEST == *"docs"* ]] || [[ $REQUEST == *"guide"* ]]; then
            echo "- Documentation Agent: For documentation"
        fi
        
        if [[ $REQUEST == *"sprint"* ]] || [[ $REQUEST == *"scrum"* ]] || [[ $REQUEST == *"agile"* ]] || [[ $REQUEST == *"standup"* ]]; then
            echo "- Scrum Master: For agile facilitation"
        fi
        
        echo ""
        echo "Consider using './scripts/meeting.sh' for collaborative decisions"
        echo "Use 'custom' command to execute this combination"
        ;;
    
    "meeting")
        # Run collaborative meeting
        MEETING_TYPE=$1
        TOPIC=$2
        
        if [ -z "$MEETING_TYPE" ] || [ -z "$TOPIC" ]; then
            echo "Usage: $0 meeting <type> \"<topic>\""
            echo "Types: planning, technical, product, retrospective, emergency, architecture, user-research"
            exit 1
        fi
        
        # Source and run meeting script functionality
        if [ -f "./scripts/meeting.sh" ]; then
            ./scripts/meeting.sh "$MEETING_TYPE" "$TOPIC"
        else
            echo "Error: meeting.sh not found"
            exit 1
        fi
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
        echo "  devops <task>        - Spawn DevOps agent with task"
        echo "  project <task>       - Spawn project manager agent with task"
        echo "  product <task>       - Spawn product manager agent with task"
        echo "  portfolio <task>     - Spawn portfolio manager agent with task"
        echo "  research <task>      - Spawn research team agent with task"
        echo "  ux <task>            - Spawn UX agent with task"
        echo "  customer <task>      - Spawn customer voice agent with task"
        echo "  scrum <task>         - Spawn scrum master agent with task"
        echo "  parallel <tasks>     - Run multiple agents in parallel"
        echo "  sequence <tasks>     - Run agents in sequence"
        echo "  workflow <feature>   - Run standard dev workflow with QA gates"
        echo "  ml-workflow <model>  - Run ML-specific workflow"
        echo "  deployment-workflow <app> - Run deployment workflow"
        echo "  product-workflow <product> - Run product dev workflow"
        echo "  analyze <request>    - Analyze and suggest agents"
        echo "  custom <tasks>       - Run custom agent combination"
        echo ""
        echo "For adaptive workflows with dynamic quality gates:"
        echo "  ../scripts/adaptive-workflow.sh adaptive 'feature description'"
        echo "  ../scripts/adaptive-workflow.sh continuous 'task description'"
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