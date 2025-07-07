# Python Multi-Agent Development Template

A clean, reusable Python project template designed for multi-agent development workflows using Claude AI agents.

## Overview

This template provides a structured approach to Python development using specialized AI agents for different aspects of the development lifecycle. Each agent has a specific role and expertise, enabling efficient collaboration and high-quality code production.

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

This template includes six specialized agents:

### 1. Architect Agent
- **Role**: System design and architecture decisions
- **Launch**: `./scripts/launch-architect.sh`
- **Responsibilities**: 
  - Design system architecture
  - Make technology choices
  - Define component interfaces
  - Create architectural documentation

### 2. Developer Agent
- **Role**: Code implementation
- **Launch**: `./scripts/launch-developer.sh`
- **Responsibilities**:
  - Implement features
  - Write clean, maintainable code
  - Follow architectural guidelines
  - Create unit tests

### 3. Tester Agent
- **Role**: Quality assurance and testing
- **Launch**: `./scripts/launch-tester.sh`
- **Responsibilities**:
  - Write comprehensive tests
  - Perform test coverage analysis
  - Identify edge cases
  - Ensure code quality

### 4. Reviewer Agent
- **Role**: Code review and best practices
- **Launch**: `./scripts/launch-reviewer.sh`
- **Responsibilities**:
  - Review code quality
  - Ensure best practices
  - Check for security issues
  - Suggest improvements

### 5. Triage Agent
- **Role**: Issue management and prioritization
- **Launch**: `./scripts/launch-triage.sh`
- **Responsibilities**:
  - Categorize issues
  - Prioritize tasks
  - Assign to appropriate agents
  - Track progress

### 6. Task Agent
- **Role**: Task breakdown and management
- **Launch**: `claude code --task "your task description"`
- **Responsibilities**:
  - Break down complex tasks
  - Create actionable subtasks
  - Coordinate between agents
  - Track completion

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