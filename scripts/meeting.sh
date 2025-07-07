#!/bin/bash

# Meeting orchestration script for multi-agent collaboration
# Usage: ./meeting.sh <meeting-type> "<topic>"

MEETING_TYPE=$1
TOPIC=$2

if [ -z "$MEETING_TYPE" ] || [ -z "$TOPIC" ]; then
    echo "Usage: $0 <meeting-type> \"<topic>\""
    echo ""
    echo "Meeting types:"
    echo "  planning     - Sprint/project planning with relevant agents"
    echo "  technical    - Technical decision making"
    echo "  product      - Product strategy and requirements"
    echo "  retrospective - Team retrospective"
    echo "  emergency    - Urgent issue resolution"
    echo "  architecture - System design decisions"
    echo "  user-research - User feedback and UX decisions"
    echo ""
    echo "Example: $0 planning \"Sprint 5 planning for authentication feature\""
    exit 1
fi

echo "🤝 Initiating Multi-Agent Meeting"
echo "Type: $MEETING_TYPE"
echo "Topic: $TOPIC"
echo ""

case "$MEETING_TYPE" in
    "planning")
        echo "📅 Sprint Planning Meeting"
        echo "Convening: Scrum Master, Product Manager, Project Manager, Developer, Tester"
        echo ""
        
        # Scrum Master facilitates
        echo "1️⃣ Scrum Master facilitating..."
        claude -p "You are the Scrum Master. First run /scrum to load your role. Facilitate a sprint planning meeting for: $TOPIC. Start by setting the agenda and sprint goal." --verbose
        
        # Product Manager presents priorities
        echo "2️⃣ Product Manager presenting priorities..."
        claude -p "You are the Product Manager. First run /product to load your role. In this sprint planning meeting, present the prioritized user stories and acceptance criteria for: $TOPIC" --verbose
        
        # Developer provides estimates
        echo "3️⃣ Developer providing technical input..."
        claude -p "You are the Developer. First run /developer to load your role. In this sprint planning meeting, provide effort estimates and technical considerations for: $TOPIC" --verbose
        
        # Tester identifies test scenarios
        echo "4️⃣ Tester outlining test approach..."
        claude -p "You are the Tester. First run /tester to load your role. In this sprint planning meeting, outline the test strategy and identify risks for: $TOPIC" --verbose
        
        # Project Manager confirms timeline
        echo "5️⃣ Project Manager confirming resources..."
        claude -p "You are the Project Manager. First run /project to load your role. In this sprint planning meeting, confirm resource allocation and timeline feasibility for: $TOPIC" --verbose
        
        # Scrum Master summarizes
        echo "6️⃣ Scrum Master summarizing decisions..."
        claude -p "You are the Scrum Master. Summarize the sprint planning outcomes, commitments, and action items from the meeting about: $TOPIC" --verbose
        ;;
    
    "technical")
        echo "🛠️ Technical Decision Meeting"
        echo "Convening: Architect, Developer, DevOps, MLOps (if needed), Research Team"
        echo ""
        
        # Architect leads
        echo "1️⃣ Architect presenting options..."
        claude -p "You are the Architect. First run /architect to load your role. Lead a technical decision meeting about: $TOPIC. Present architectural options with pros/cons." --verbose
        
        # Research provides data
        echo "2️⃣ Research Team providing analysis..."
        claude -p "You are the Research Team. First run /research to load your role. In this technical meeting, provide research findings and benchmarks relevant to: $TOPIC" --verbose
        
        # Developer discusses implementation
        echo "3️⃣ Developer discussing implementation..."
        claude -p "You are the Developer. First run /developer to load your role. In this technical meeting, discuss implementation complexity and preferences for: $TOPIC" --verbose
        
        # DevOps covers deployment
        echo "4️⃣ DevOps addressing infrastructure..."
        claude -p "You are the DevOps Agent. First run /devops to load your role. In this technical meeting, address deployment and infrastructure considerations for: $TOPIC" --verbose
        
        # Architect synthesizes decision
        echo "5️⃣ Architect documenting decision..."
        claude -p "You are the Architect. Synthesize the technical discussion and document the architectural decision record (ADR) for: $TOPIC" --verbose
        ;;
    
    "product")
        echo "📦 Product Strategy Meeting"
        echo "Convening: Product Manager, Customer Voice, UX, Research Team, Portfolio Manager"
        echo ""
        
        # Product Manager leads
        echo "1️⃣ Product Manager setting context..."
        claude -p "You are the Product Manager. First run /product to load your role. Lead a product strategy meeting about: $TOPIC. Present the opportunity and objectives." --verbose
        
        # Customer Voice shares feedback
        echo "2️⃣ Customer Voice sharing insights..."
        claude -p "You are the Customer Voice. First run /customer to load your role. In this product meeting, share user feedback and needs related to: $TOPIC" --verbose
        
        # Research presents market data
        echo "3️⃣ Research Team presenting market analysis..."
        claude -p "You are the Research Team. First run /research to load your role. In this product meeting, present market analysis and competitive landscape for: $TOPIC" --verbose
        
        # UX proposes solutions
        echo "4️⃣ UX proposing design approach..."
        claude -p "You are the UX Agent. First run /ux to load your role. In this product meeting, propose user experience solutions for: $TOPIC" --verbose
        
        # Portfolio Manager assesses fit
        echo "5️⃣ Portfolio Manager evaluating alignment..."
        claude -p "You are the Portfolio Manager. First run /portfolio to load your role. In this product meeting, assess strategic fit and resource implications for: $TOPIC" --verbose
        
        # Product Manager concludes
        echo "6️⃣ Product Manager finalizing direction..."
        claude -p "You are the Product Manager. Synthesize the product discussion and define the product direction and next steps for: $TOPIC" --verbose
        ;;
    
    "retrospective")
        echo "🔄 Sprint Retrospective Meeting"
        echo "Convening: Scrum Master, entire team"
        echo ""
        
        # Scrum Master facilitates
        echo "1️⃣ Scrum Master opening retrospective..."
        claude -p "You are the Scrum Master. First run /scrum to load your role. Facilitate a retrospective meeting about: $TOPIC. Start with a team check-in and set the stage." --verbose
        
        # Each team member contributes
        echo "2️⃣ Gathering team perspectives..."
        claude -p "You are the Developer. First run /developer to load your role. In this retrospective, share what went well, what could improve, and ideas for: $TOPIC" --verbose
        claude -p "You are the Tester. First run /tester to load your role. In this retrospective, share your perspective on quality and testing for: $TOPIC" --verbose
        claude -p "You are the DevOps Agent. First run /devops to load your role. In this retrospective, share insights on deployment and operations for: $TOPIC" --verbose
        
        # Scrum Master facilitates actions
        echo "3️⃣ Scrum Master facilitating action items..."
        claude -p "You are the Scrum Master. Facilitate the team in identifying specific action items and improvements based on the retrospective about: $TOPIC" --verbose
        ;;
    
    "emergency")
        echo "🚨 Emergency Response Meeting"
        echo "Convening: Relevant agents based on issue"
        echo ""
        
        # Triage assesses
        echo "1️⃣ Triage assessing situation..."
        claude -p "You are the Triage Agent. First run /triage to load your role. Assess the emergency situation and identify required experts for: $TOPIC" --verbose
        
        # Gather relevant agents
        echo "2️⃣ Convening emergency response team..."
        claude -p "Based on the emergency assessment, execute: ./scripts/orchestrate.sh custom \"devops:assess impact,developer:identify fix,tester:verify solution,customer:communicate status\" for: $TOPIC" --verbose
        ;;
    
    "architecture")
        echo "🏗️ Architecture Review Board"
        echo "Convening: Architect, Senior Developers, DevOps, Security Expert"
        echo ""
        
        echo "1️⃣ Architect presenting design..."
        claude -p "You are the Architect. First run /architect to load your role. Present the architectural proposal for review regarding: $TOPIC" --verbose
        
        echo "2️⃣ Reviewer conducting security review..."
        claude -p "You are the Reviewer. First run /reviewer to load your role. Conduct a security and best practices review of the architecture for: $TOPIC" --verbose
        
        echo "3️⃣ DevOps reviewing operability..."
        claude -p "You are the DevOps Agent. First run /devops to load your role. Review the operational aspects and deployment considerations for: $TOPIC" --verbose
        
        echo "4️⃣ Architect incorporating feedback..."
        claude -p "You are the Architect. Incorporate the review feedback and finalize the architecture for: $TOPIC" --verbose
        ;;
    
    "user-research")
        echo "👥 User Research & Design Meeting"
        echo "Convening: UX, Customer Voice, Product Manager, Research Team"
        echo ""
        
        echo "1️⃣ Customer Voice presenting findings..."
        claude -p "You are the Customer Voice. First run /customer to load your role. Present user research findings and feedback for: $TOPIC" --verbose
        
        echo "2️⃣ UX analyzing user needs..."
        claude -p "You are the UX Agent. First run /ux to load your role. Analyze the user research and identify design opportunities for: $TOPIC" --verbose
        
        echo "3️⃣ Research Team providing context..."
        claude -p "You are the Research Team. First run /research to load your role. Provide industry best practices and competitor analysis for: $TOPIC" --verbose
        
        echo "4️⃣ Product Manager prioritizing..."
        claude -p "You are the Product Manager. First run /product to load your role. Based on the research, prioritize features and define success metrics for: $TOPIC" --verbose
        ;;
    
    *)
        echo "Unknown meeting type: $MEETING_TYPE"
        exit 1
        ;;
esac

echo ""
echo "✅ Meeting concluded"
echo "📝 Action items have been documented in the taskboard"