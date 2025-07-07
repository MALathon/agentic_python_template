# Agentic Python Template

A Python project template with multi-agent orchestration capabilities for AI-assisted development.

## 🎯 Purpose

This template provides a complete multi-agent development environment where specialized AI agents collaborate on different aspects of your project:

- **14 Specialized Agents**: From architecture to testing to deployment
- **Intelligent Orchestration**: Triage agent interprets your needs and coordinates others
- **Collaborative Decision Making**: Multi-agent meetings for complex decisions
- **No Attribution Required**: Clean commits without AI attribution

## 🚀 Quick Start

1. **Clone this template**:
   ```bash
   git clone https://github.com/yourusername/agentic_python_template.git myproject
   cd myproject
   rm -rf .git  # Remove template's git history
   git init     # Start fresh for your project
   ```

2. **Start using agents**:
   ```bash
   # Let triage interpret what you need
   claude /triage "I need to build a REST API with authentication"
   
   # Or launch specific agents
   ./scripts/launch-agent.sh architect
   ./scripts/launch-agent.sh developer
   ```

3. **For complex decisions**:
   ```bash
   # Hold a planning meeting
   ./scripts/meeting.sh planning "Sprint 1 - API Development"
   
   # Technical architecture review
   ./scripts/meeting.sh architecture "Microservices vs Monolith"
   ```

## 🤖 Available Agents

| Agent | Role | Launch Command |
|-------|------|----------------|
| **Triage** | Interprets requests & orchestrates | `claude /triage` |
| **Architect** | System design & architecture | `./scripts/launch-agent.sh architect` |
| **Developer** | Implementation & coding | `./scripts/launch-agent.sh developer` |
| **Tester** | Quality assurance & testing | `./scripts/launch-agent.sh tester` |
| **Reviewer** | Code review & security | `./scripts/launch-agent.sh reviewer` |
| **Documentation** | Technical documentation | `./scripts/launch-agent.sh documentation` |
| **MLOps** | ML infrastructure & operations | `./scripts/launch-agent.sh mlops` |
| **DevOps** | CI/CD & deployment | `./scripts/launch-agent.sh devops` |
| **Project Manager** | Planning & coordination | `./scripts/launch-agent.sh project` |
| **Product Manager** | Strategy & requirements | `./scripts/launch-agent.sh product` |
| **Portfolio Manager** | Multi-project oversight | `./scripts/launch-agent.sh portfolio` |
| **Research Team** | Technology research | `./scripts/launch-agent.sh research` |
| **UX** | User experience design | `./scripts/launch-agent.sh ux` |
| **Customer Voice** | User feedback & validation | `./scripts/launch-agent.sh customer` |
| **Scrum Master** | Agile facilitation | `./scripts/launch-agent.sh scrum` |

## 🧪 Testing Strategy

This template includes a dual-layer testing approach:

### For Template Maintainers
Tests that validate the template itself works correctly:
```bash
# Run template validation
./scripts/validate-template.sh

# Run Python tests for template structure
pytest tests/template/

# Check prompt consistency
python tests/template/validate_prompts.py
```

### For Your Project
Example tests for your actual application:
```bash
# Your application tests go in tests/
pytest tests/

# Template tests are separate in tests/template/
# You can safely ignore or delete tests/template/
```

## 📦 What's Included

```
agentic_python_template/
├── .claude/
│   ├── commands/      # Agent definitions (15 agents)
│   ├── rules/         # Project rules (includes no-attribution)
│   └── tasks/         # Centralized taskboard
├── .github/
│   └── workflows/     # CI/CD for template validation
├── scripts/
│   ├── orchestrate.sh # Dynamic agent orchestration
│   ├── meeting.sh     # Multi-agent meetings
│   ├── launch-*.sh    # Individual agent launchers
│   └── validate-template.sh  # Template validation
├── tests/
│   ├── template/      # Template validation tests (not for users)
│   └── example/       # Example tests for your project
├── src/               # Your source code goes here
├── docs/              # Your documentation
└── README.md          # This file
```

## 🌟 Key Features

### Intelligent Orchestration
The Triage agent interprets your natural language requests:
```bash
# Triage figures out what you need
claude /triage "Deploy my app to production with monitoring"
# Automatically orchestrates: DevOps + Architect + Developer + Documentation
```

### Dynamic Agent Composition
```bash
# Parallel execution
./scripts/orchestrate.sh parallel "architect:design API,developer:setup project"

# Sequential workflow
./scripts/orchestrate.sh sequence "architect:design,developer:implement,tester:verify"

# Custom combinations
./scripts/orchestrate.sh custom "research:analyze market,product:define features,ux:create designs"
```

### Collaborative Meetings
```bash
# Different meeting types for different needs
./scripts/meeting.sh planning "Q2 Roadmap"
./scripts/meeting.sh technical "Database Selection"
./scripts/meeting.sh retrospective "Sprint 3 Review"
./scripts/meeting.sh emergency "Production Issue"
```

### No AI Attribution
All commits are clean - no "Generated by AI" or "Co-authored-by Claude" messages. Your git history stays professional.

## 🔧 Customization

### Adding Your Own Project Structure
1. Add your code to `src/`
2. Add your tests to `tests/`
3. Update `requirements.txt` with your dependencies
4. The agents will adapt to your project structure

### Modifying Agent Behavior
- Edit agent prompts in `.claude/commands/`
- Adjust orchestration logic in `scripts/orchestrate.sh`
- Add new meeting types in `scripts/meeting.sh`

### Removing Template Tests
Once you've started your project:
```bash
# Remove template validation (optional)
rm -rf tests/template/
rm -f scripts/validate-template.sh
rm -rf .github/workflows/template-validation.yml
```

## 🔍 Template Maintenance

If you're maintaining this template (not just using it):

1. **Validate Changes**: Run `./scripts/validate-template.sh`
2. **Update Baselines**: `python tests/template/validate_prompts.py --update`
3. **CI/CD**: GitHub Actions run weekly to catch model drift
4. **Test Coverage**: Ensure all agents remain functional

## 📝 License

This template is provided as-is for creating AI-assisted development environments.
Your project code remains entirely yours with no attribution required.