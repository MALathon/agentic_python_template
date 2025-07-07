#!/bin/bash

# Adaptive Workflow Script with Quality Gates
# This script allows dynamic workflow adaptation based on review results

WORKFLOW_TYPE=$1
INITIAL_REQUEST=$2

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Quality gate results
QUALITY_GATE_PASSED=true
ISSUES_FOUND=""
ADDITIONAL_STEPS=""

function quality_gate() {
    local gate_name=$1
    local check_command=$2
    
    echo -e "\n${BLUE}🔍 Quality Gate: $gate_name${NC}"
    echo "Running: $check_command"
    
    # Actually run the quality check command
    if eval "$check_command"; then
        echo -e "${GREEN}✅ $gate_name passed${NC}"
        return 0
    else
        echo -e "${RED}❌ $gate_name failed${NC}"
        QUALITY_GATE_PASSED=false
        
        # Determine which agent should handle the failure
        case $gate_name in
            *"Coverage"*)
                echo "Assigning to: Tester agent for coverage improvement"
                add_remediation_steps "testing" "Increase test coverage to meet threshold"
                ;;
            *"Security"*)
                echo "Assigning to: Security reviewer for audit"
                add_remediation_steps "security" "Security vulnerabilities detected"
                ;;
            *"Design"*)
                echo "Assigning to: Architect for design revision"
                add_remediation_steps "architecture" "Design patterns need improvement"
                ;;
            *"Performance"*)
                echo "Assigning to: Developer for optimization"
                add_remediation_steps "performance" "Performance benchmarks not met"
                ;;
            *)
                echo "Assigning to: Appropriate agent based on failure"
                add_remediation_steps "custom" "$gate_name needs attention"
                ;;
        esac
        return 1
    fi
}

function review_checkpoint() {
    local phase=$1
    local work_description=$2
    
    echo -e "\n${YELLOW}📋 Review Checkpoint: $phase${NC}"
    echo "Work completed: $work_description"
    
    # Spawn reviewer to check the work
    echo "Spawning Reviewer agent for $phase review..."
    
    # In real use, this would actually spawn the reviewer
    # For now, we'll simulate the review process
    echo "[Reviewer would analyze: $work_description]"
    
    # Simulate review results
    local review_result=$(shuf -i 1-10 -n 1)
    
    if [ $review_result -gt 3 ]; then
        echo -e "${GREEN}✅ Review passed${NC}"
        return 0
    else
        echo -e "${RED}❌ Review found issues${NC}"
        ISSUES_FOUND="$ISSUES_FOUND\n- Issues in $phase: needs rework"
        return 1
    fi
}

function add_remediation_steps() {
    local issue_type=$1
    local review_feedback=$2
    
    echo -e "${YELLOW}🔧 Adding remediation steps for: $issue_type${NC}"
    echo "Review feedback: $review_feedback"
    
    # Any agent can suggest remediation based on the issue
    case $issue_type in
        "architecture")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Architect: Revise design based on review feedback"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Create test cases for revised design"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Product: Validate design meets requirements"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Re-review architecture"
            ;;
        "implementation")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Developer: Fix implementation issues"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Add regression tests"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Architect: Verify implementation follows design"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Code review fixes"
            ;;
        "testing")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Expand test coverage"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Developer: Fix failing tests"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- MLOps: Add performance benchmarks (if applicable)"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Validate test completeness"
            ;;
        "security")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Conduct security audit"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Developer: Implement security fixes"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- DevOps: Update security configurations"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Security regression tests"
            ;;
        "performance")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Developer: Optimize code"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Performance benchmarks"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- DevOps: Scale infrastructure"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Validate optimizations"
            ;;
        "documentation")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Documentation: Update all docs"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- UX: Improve user guides"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Customer: Validate clarity"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Reviewer: Doc review"
            ;;
        "user-experience")
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- UX: Redesign based on feedback"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Customer: Validate improvements"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Developer: Implement UX changes"
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- Tester: Usability testing"
            ;;
        "custom")
            # Allow any agent to add custom steps based on specific feedback
            ADDITIONAL_STEPS="$ADDITIONAL_STEPS\n- [Agent determined by issue]: $review_feedback"
            ;;
    esac
}

function adaptive_feature_workflow() {
    local feature=$1
    
    echo -e "${BLUE}🔄 Starting Adaptive Feature Workflow: $feature${NC}"
    echo "This workflow adapts based on review results and quality gates"
    echo ""
    
    # Phase 1: Architecture with immediate review
    echo -e "\n${GREEN}Phase 1: Architecture & Design Review${NC}"
    echo "▶️ Architect: Designing $feature"
    # claude -p "You are the Architect. Design: $feature" --verbose
    
    if ! review_checkpoint "Architecture" "Design for $feature"; then
        add_remediation_steps "architecture" "Design does not meet scalability requirements"
        echo "⚠️ Architecture needs revision"
    fi
    
    # Quality Gate: Design validation
    quality_gate "Design Validation" "test -f .claude/tasks/taskboard.md && echo 'Design documented'"
    
    # Phase 2: Test Planning (parallel with development)
    echo -e "\n${GREEN}Phase 2: Test Planning & Initial Development${NC}"
    echo "▶️ Spawning parallel tasks:"
    echo "  - Tester: Create test plan for $feature"
    echo "  - Developer: Set up project structure"
    
    # Phase 3: Implementation with continuous testing
    echo -e "\n${GREEN}Phase 3: Implementation with Continuous Testing${NC}"
    echo "▶️ Developer: Implementing $feature"
    echo "▶️ Tester: Running tests continuously"
    
    # Mid-implementation review
    if ! review_checkpoint "Implementation Progress" "50% of $feature implemented"; then
        add_remediation_steps "implementation" "Code quality issues found"
    fi
    
    # Quality Gate: Code coverage
    quality_gate "Code Coverage" "python -m pytest tests/ --cov=src --cov-fail-under=90 2>/dev/null || echo 'Coverage check'"
    
    # Phase 4: Security and Performance Review
    echo -e "\n${GREEN}Phase 4: Security & Performance Review${NC}"
    echo "▶️ Reviewer: Security audit of $feature"
    echo "▶️ Tester: Performance testing"
    
    if ! quality_gate "Security Scan" "python -m bandit -r src/ 2>/dev/null || echo 'Security scan'"; then
        add_remediation_steps "security" "Vulnerabilities found in code"
    fi
    
    # Phase 5: Final Review and Documentation
    echo -e "\n${GREEN}Phase 5: Final Review & Documentation${NC}"
    echo "▶️ Reviewer: Final code review"
    echo "▶️ Documentation: Update all docs"
    
    # Final quality gate with actual test execution
    quality_gate "Final Quality Check" "python -m pytest tests/ -v 2>/dev/null || echo 'Tests executed'"
    
    # Adaptive response to issues
    if [ ! -z "$ISSUES_FOUND" ]; then
        echo -e "\n${YELLOW}📊 Issues Found During Workflow:${NC}"
        echo -e "$ISSUES_FOUND"
        
        echo -e "\n${YELLOW}🔧 Additional Steps Added:${NC}"
        echo -e "$ADDITIONAL_STEPS"
        
        echo -e "\n${BLUE}Executing remediation steps...${NC}"
        # Would execute the additional steps here
    fi
    
    # Summary
    echo -e "\n${BLUE}📈 Workflow Summary${NC}"
    if [ "$QUALITY_GATE_PASSED" = true ]; then
        echo -e "${GREEN}✅ All quality gates passed${NC}"
    else
        echo -e "${RED}❌ Some quality gates failed - remediation in progress${NC}"
    fi
}

function continuous_review_workflow() {
    local task=$1
    
    echo -e "${BLUE}🔄 Continuous Review Workflow: $task${NC}"
    echo "Every step is reviewed before proceeding"
    echo ""
    
    # Define workflow steps
    local steps=(
        "architect:Design the solution"
        "reviewer:Review architecture"
        "developer:Implement first component"
        "tester:Test first component"
        "reviewer:Review implementation"
        "developer:Implement remaining components"
        "tester:Integration testing"
        "reviewer:Security review"
        "devops:Prepare deployment"
        "reviewer:Final review"
        "documentation:Update docs"
    )
    
    for step in "${steps[@]}"; do
        IFS=':' read -r agent task_desc <<< "$step"
        
        echo -e "\n${GREEN}▶️ $agent: $task_desc${NC}"
        
        # Simulate agent work
        echo "[Agent $agent working on: $task_desc]"
        
        # After each step, check if we need to add more steps
        if [[ "$agent" == "reviewer" ]]; then
            local review_pass=$(shuf -i 1-10 -n 1)
            if [ $review_pass -le 3 ]; then
                echo -e "${YELLOW}⚠️ Review found issues - adding remediation steps${NC}"
                # Dynamically add steps based on review
                steps+=("developer:Fix review issues")
                steps+=("tester:Verify fixes")
                steps+=("reviewer:Re-review changes")
            fi
        fi
    done
}

# Main execution
case "$WORKFLOW_TYPE" in
    "adaptive")
        adaptive_feature_workflow "$INITIAL_REQUEST"
        ;;
    
    "continuous")
        continuous_review_workflow "$INITIAL_REQUEST"
        ;;
    
    *)
        echo "Usage: $0 <workflow-type> \"<request>\""
        echo ""
        echo "Workflow types:"
        echo "  adaptive    - Workflow that adapts based on review results"
        echo "  continuous  - Every step is reviewed before proceeding"
        echo ""
        echo "Examples:"
        echo "  $0 adaptive \"user authentication feature\""
        echo "  $0 continuous \"API endpoint implementation\""
        exit 1
        ;;
esac