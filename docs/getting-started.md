# Getting Started

Welcome to the Python Multi-Agent Development Template!

## Prerequisites

- Python 3.8 or later
- Claude CLI (Claude Code)
- Git

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd <your-project>
   ```

2. **Run the setup script**
   ```bash
   chmod +x scripts/setup-agents.sh
   ./scripts/setup-agents.sh
   ```

3. **Activate the virtual environment**
   ```bash
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

4. **Install dependencies**
   ```bash
   pip install -r requirements-dev.txt
   ```

5. **Start developing with agents**
   ```bash
   # Break down a complex task
   claude code --task "Build a REST API for user management"
   
   # Or use specific agents
   ./scripts/launch-developer.sh
   ```

## Project Structure

```
.
├── .claude/           # Agent configurations
├── src/              # Source code
├── tests/            # Test suites
├── docs/             # Documentation
├── scripts/          # Utility scripts
└── pyproject.toml    # Project configuration
```

## Using the Agents

### Task Agent
Start here to break down complex projects:
```bash
claude code --task "Your project description"
```

### Specialized Agents
- **Architect**: System design and architecture
- **Developer**: Code implementation
- **Tester**: Quality assurance
- **Reviewer**: Code review
- **Triage**: Issue management

## Development Workflow

1. Start with the Task agent to plan your work
2. Use the Architect agent for design decisions
3. Implement with the Developer agent
4. Test with the Tester agent
5. Review with the Reviewer agent
6. Manage issues with the Triage agent

## Best Practices

- Always activate your virtual environment
- Run tests before committing
- Follow the project rules in `.claude/rules/project.md`
- Use pre-commit hooks for code quality
- Keep documentation up to date

## Getting Help

- Check the agent command files in `.claude/commands/`
- Review the project rules in `.claude/rules/`
- Consult the README.md for overview
- Use the appropriate agent for guidance