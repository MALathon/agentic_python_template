# Python Multi-Agent Development Template

A comprehensive ecosystem of 13 specialized AI agents covering the entire product development lifecycle - from strategy and user research to implementation and deployment.

## Overview

This template provides a complete product development platform using specialized Claude AI agents. Whether you're building a startup MVP, enterprise software, or ML systems, the agents work together to handle every aspect from ideation to production.

**Key Features:**
- 🤖 **13 Specialized Agents** - Complete coverage of product development
- 🔄 **Dynamic Orchestration** - Mix and match agents for any task
- 🎯 **Intelligent Routing** - Automatic agent selection based on needs
- 📋 **Built-in Workflows** - Pre-configured for common scenarios
- 🚀 **Headless Automation** - Agents can spawn other agents as needed

## Project Structure

```
.
├── .claude/
│   ├── commands/    # Agent command files defining roles and responsibilities
│   ├── rules/       # Project-specific rules and guidelines
│   └── tasks/       # Task management and tracking
├── scripts/         # Agent launch scripts
├── src/            # Source code
├── tests/          # Test files
├── docs/           # Documentation
├── pyproject.toml  # Project configuration
├── requirements.txt # Python dependencies
└── README.md       # This file
```

## Agents

This template includes **13 specialized agents** covering the entire product development lifecycle:

### Development & Technical Agents

#### 1. Architect Agent
- **Role**: System design and architecture decisions
- **Launch**: `./scripts/launch-architect.sh`
- **Command**: `/architect`

#### 2. Developer Agent
- **Role**: Code implementation with TDD
- **Launch**: `./scripts/launch-developer.sh`
- **Command**: `/developer`

#### 3. Tester Agent
- **Role**: Quality assurance and testing
- **Launch**: `./scripts/launch-tester.sh`
- **Command**: `/tester`

#### 4. Reviewer Agent
- **Role**: Code review and quality standards
- **Launch**: `./scripts/launch-reviewer.sh`
- **Command**: `/reviewer`

### Operations & Infrastructure Agents

#### 5. DevOps Agent
- **Role**: CI/CD, deployment, and infrastructure
- **Launch**: `./scripts/launch-devops.sh`
- **Command**: `/devops`

#### 6. MLOps Agent
- **Role**: ML infrastructure and model deployment
- **Launch**: `./scripts/launch-mlops.sh`
- **Command**: `/mlops`

### Product & Strategy Agents

#### 7. Product Manager Agent
- **Role**: Product strategy, roadmap, and requirements
- **Launch**: `./scripts/launch-product.sh`
- **Command**: `/product`

#### 8. Project Manager Agent
- **Role**: Project planning, timelines, and resources
- **Launch**: `./scripts/launch-project.sh`
- **Command**: `/project`

#### 9. Portfolio Manager Agent
- **Role**: Multi-project oversight and investment decisions
- **Launch**: `./scripts/launch-portfolio.sh`
- **Command**: `/portfolio`

### User Experience & Research Agents

#### 10. UX Agent
- **Role**: UI/UX design and user research
- **Launch**: `./scripts/launch-ux.sh`
- **Command**: `/ux`

#### 11. Customer Voice Agent
- **Role**: User feedback and validation
- **Launch**: `./scripts/launch-customer.sh`
- **Command**: `/customer`

#### 12. Research Team Agent
- **Role**: Technology research and competitive analysis
- **Launch**: `./scripts/launch-research.sh`
- **Command**: `/research`

### Coordination Agent

#### 13. Triage Agent
- **Role**: Task orchestration and intelligent routing
- **Launch**: `./scripts/launch-triage.sh`
- **Command**: `/triage`

## Dynamic Agent Orchestration

The template includes powerful orchestration capabilities for combining agents:

### Analyze Request
```bash
# Analyze any request to get agent recommendations
./scripts/orchestrate.sh analyze "build a user-friendly dashboard with real-time data"
```

### Pre-built Workflows

#### Standard Development Workflow
```bash
./scripts/orchestrate.sh workflow "user authentication feature"
```

#### Product Development Workflow
```bash
./scripts/orchestrate.sh product-workflow "new SaaS platform"
```

#### ML Project Workflow
```bash
./scripts/orchestrate.sh ml-workflow "recommendation engine"
```

#### Deployment Workflow
```bash
./scripts/orchestrate.sh deployment-workflow "my-app"
```

### Custom Agent Combinations

#### Parallel Execution
```bash
# Run multiple agents simultaneously
./scripts/orchestrate.sh parallel "ux:design mockups,developer:setup project,devops:prepare infrastructure"
```

#### Sequential Execution
```bash
# Run agents in order with dependencies
./scripts/orchestrate.sh sequence "architect:design system,developer:implement,tester:validate"
```

#### Custom Orchestration
```bash
# Define your own agent combination
./scripts/orchestrate.sh custom "customer:gather feedback,product:prioritize,ux:design,developer:implement,customer:validate"
```

### Example Orchestrations

**Full Product Launch:**
```bash
./scripts/orchestrate.sh custom "product:define vision,research:market analysis,ux:user research,architect:system design,project:create plan,developer:build MVP,tester:validate,devops:deploy,customer:gather feedback"
```

**User Experience Improvement:**
```bash
./scripts/orchestrate.sh custom "customer:collect feedback,ux:analyze issues,research:competitor analysis,ux:redesign,developer:implement changes,tester:usability testing,customer:validate improvements"
```

**Technology Migration:**
```bash
./scripts/orchestrate.sh custom "research:evaluate options,portfolio:assess impact,architect:migration plan,project:timeline,developer:implement,tester:regression testing,devops:rollout strategy"
```

## Getting Started

### 1. Setup the Environment

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Setup the agents
./scripts/setup-agents.sh

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Using Agents

Start with the Task agent to break down your project:
```bash
claude code --task "Build a web scraping tool"
```

Then use specialized agents as needed:
```bash
# Design the architecture
./scripts/launch-architect.sh

# Implement features
./scripts/launch-developer.sh

# Write tests
./scripts/launch-tester.sh

# Review code
./scripts/launch-reviewer.sh
```

### 3. Project Rules

The `.claude/rules/project.md` file contains important project guidelines, including:
- Code style preferences
- Testing requirements
- Documentation standards
- Git commit conventions

## Customization

### Adding Project-Specific Configuration

1. Edit `pyproject.toml` to update project metadata
2. Modify `.claude/rules/project.md` to add your coding standards
3. Update agent commands in `.claude/commands/` for your workflow
4. Add project-specific dependencies to `requirements.txt`

### Creating Custom Agents

To create a new agent:

1. Create a command file in `.claude/commands/`
2. Define the agent's role and responsibilities
3. Create a launch script in `scripts/`
4. Document the agent in this README

## Best Practices

1. **Start with Task Agent**: Always begin by breaking down complex tasks
2. **Use Appropriate Agents**: Match agents to their specialized roles
3. **Maintain Context**: Keep `.claude/tasks/` updated with progress
4. **Follow Rules**: Adhere to guidelines in `.claude/rules/`
5. **Iterate**: Use Reviewer agent regularly for continuous improvement

## Project Layout

### Source Code (`src/`)
Place your Python packages and modules here. The template includes a basic structure that you can expand.

### Tests (`tests/`)
Mirror your source structure in the tests directory. Use pytest for testing.

### Documentation (`docs/`)
Keep your documentation organized and up-to-date. Consider using Sphinx for API documentation.

## Contributing

When contributing to projects using this template:

1. Use the appropriate agent for your task
2. Follow the project rules and guidelines
3. Ensure all tests pass
4. Get code reviewed by the Reviewer agent
5. Update documentation as needed

## License

This template is provided as-is for use in Python projects. Customize the license as needed for your specific project.

---

Built for efficient multi-agent development workflows with Claude AI.