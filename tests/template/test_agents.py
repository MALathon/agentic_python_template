#!/usr/bin/env python3
"""
Template Validation Tests - Agent Functionality

These tests are for template maintainers to ensure agents work correctly
across Claude model updates. End users should NOT run these tests.
"""

import subprocess
import os
import sys
import json
import time
from pathlib import Path
import pytest


class TestAgentFunctionality:
    """Test that all agents can be launched and respond correctly."""
    
    @pytest.fixture
    def project_root(self):
        """Get the project root directory."""
        return Path(__file__).parent.parent.parent
    
    def test_orchestration_script_exists(self, project_root):
        """Verify orchestration script is present and executable."""
        orchestrate_path = project_root / "scripts" / "orchestrate.sh"
        assert orchestrate_path.exists(), "orchestrate.sh not found"
        assert os.access(orchestrate_path, os.X_OK), "orchestrate.sh not executable"
    
    def test_meeting_script_exists(self, project_root):
        """Verify meeting script is present and executable."""
        meeting_path = project_root / "scripts" / "meeting.sh"
        assert meeting_path.exists(), "meeting.sh not found"
        assert os.access(meeting_path, os.X_OK), "meeting.sh not executable"
    
    def test_all_agent_commands_exist(self, project_root):
        """Verify all agent command files exist."""
        agents = [
            "architect", "developer", "tester", "reviewer", "documentation",
            "mlops", "devops", "project", "product", "portfolio",
            "research", "ux", "customer", "scrum", "triage"
        ]
        
        commands_dir = project_root / ".claude" / "commands"
        for agent in agents:
            command_file = commands_dir / f"{agent}.md"
            assert command_file.exists(), f"Missing command file for {agent} agent"
    
    def test_launch_scripts_exist(self, project_root):
        """Verify all launch scripts exist and are executable."""
        scripts_dir = project_root / "scripts"
        expected_scripts = [
            "launch-architect.sh", "launch-developer.sh", "launch-tester.sh",
            "launch-reviewer.sh", "launch-documentation.sh", "launch-mlops.sh",
            "launch-devops.sh", "launch-project.sh", "launch-product.sh",
            "launch-portfolio.sh", "launch-research.sh", "launch-ux.sh",
            "launch-customer.sh", "launch-scrum.sh"
        ]
        
        for script in expected_scripts:
            script_path = scripts_dir / script
            assert script_path.exists(), f"Missing launch script: {script}"
            assert os.access(script_path, os.X_OK), f"Launch script not executable: {script}"
    
    @pytest.mark.skipif(not os.environ.get("RUN_AGENT_TESTS"), 
                        reason="Agent tests only run in CI or with RUN_AGENT_TESTS=1")
    def test_orchestration_analyze(self, project_root):
        """Test orchestration analyze functionality."""
        result = subprocess.run(
            ["./scripts/orchestrate.sh", "analyze", "implement user authentication"],
            cwd=project_root,
            capture_output=True,
            text=True
        )
        
        assert result.returncode == 0, f"Orchestration failed: {result.stderr}"
        assert "Architect Agent" in result.stdout
        assert "Developer Agent" in result.stdout
    
    def test_orchestration_help(self, project_root):
        """Test orchestration help functionality."""
        result = subprocess.run(
            ["./scripts/orchestrate.sh"],
            cwd=project_root,
            capture_output=True,
            text=True
        )
        
        # Should show usage when no args provided
        assert "Usage:" in result.stdout
        assert "architect" in result.stdout
        assert "developer" in result.stdout
        assert "parallel" in result.stdout


class TestAgentCoordination:
    """Test agent coordination mechanisms."""
    
    def test_taskboard_structure(self):
        """Verify taskboard has correct structure."""
        taskboard_path = Path(".claude/tasks/taskboard.md")
        assert taskboard_path.exists(), "Taskboard not found"
        
        content = taskboard_path.read_text()
        required_sections = [
            "## Current Sprint",
            "### In Progress",
            "### Review",
            "### Testing",
            "## Backlog",
            "## Agent Assignments"
        ]
        
        for section in required_sections:
            assert section in content, f"Missing taskboard section: {section}"
    
    def test_project_rules_exist(self):
        """Verify project rules include attribution rules."""
        rules_path = Path(".claude/rules/project.md")
        assert rules_path.exists(), "Project rules not found"
        
        content = rules_path.read_text()
        assert "Code Attribution Rules" in content
        assert "DO NOT include Claude attribution" in content


class TestPromptStability:
    """Test that prompts maintain expected structure."""
    
    def test_agent_prompts_have_required_sections(self):
        """Verify all agent prompts have required sections."""
        commands_dir = Path(".claude/commands")
        
        for command_file in commands_dir.glob("*.md"):
            content = command_file.read_text()
            agent_name = command_file.stem
            
            # All agents should have a role section
            assert "## Role" in content or "You are" in content, \
                f"{agent_name} missing role definition"
            
            # Most agents should have responsibilities
            if agent_name != "triage":  # Triage has different structure
                assert "## Responsibilities" in content or "## Primary Responsibilities" in content, \
                    f"{agent_name} missing responsibilities section"