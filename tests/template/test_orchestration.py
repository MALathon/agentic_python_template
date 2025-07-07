#!/usr/bin/env python3
"""
Template Validation Tests - Orchestration Scripts

Tests for orchestration and meeting scripts functionality.
These ensure the multi-agent coordination works correctly.
"""

import subprocess
import os
from pathlib import Path
import pytest
import re


class TestOrchestrationScripts:
    """Test orchestration script functionality."""
    
    @pytest.fixture
    def project_root(self):
        return Path(__file__).parent.parent.parent
    
    def test_orchestrate_script_syntax(self, project_root):
        """Verify orchestration script has valid bash syntax."""
        result = subprocess.run(
            ["bash", "-n", "scripts/orchestrate.sh"],
            cwd=project_root,
            capture_output=True
        )
        assert result.returncode == 0, f"Syntax error in orchestrate.sh: {result.stderr}"
    
    def test_meeting_script_syntax(self, project_root):
        """Verify meeting script has valid bash syntax."""
        result = subprocess.run(
            ["bash", "-n", "scripts/meeting.sh"],
            cwd=project_root,
            capture_output=True
        )
        assert result.returncode == 0, f"Syntax error in meeting.sh: {result.stderr}"
    
    def test_all_agents_in_orchestration(self, project_root):
        """Verify all agents are included in orchestration script."""
        with open(project_root / "scripts/orchestrate.sh", "r") as f:
            content = f.read()
        
        agents = [
            "architect", "developer", "tester", "reviewer", "documentation",
            "mlops", "devops", "project", "product", "portfolio",
            "research", "ux", "customer", "scrum"
        ]
        
        for agent in agents:
            # Check agent is in case statement
            assert f'"{agent}"' in content, f"Agent {agent} not found in orchestration"
            # Check agent has launch command
            assert f'/$agent to load your role' in content, f"Agent {agent} missing launch command"
    
    def test_meeting_types(self, project_root):
        """Verify all meeting types are implemented."""
        with open(project_root / "scripts/meeting.sh", "r") as f:
            content = f.read()
        
        meeting_types = [
            "planning", "technical", "product", "retrospective",
            "emergency", "architecture", "user-research"
        ]
        
        for meeting in meeting_types:
            assert f'"{meeting}"' in content, f"Meeting type {meeting} not implemented"
    
    def test_orchestration_modes(self, project_root):
        """Test different orchestration modes."""
        modes = [
            (["./scripts/orchestrate.sh", "analyze", "test"], "Analyzing request"),
            (["./scripts/orchestrate.sh"], "Usage:"),
        ]
        
        for cmd, expected in modes:
            result = subprocess.run(
                cmd,
                cwd=project_root,
                capture_output=True,
                text=True
            )
            assert expected in result.stdout, f"Mode {cmd[1] if len(cmd) > 1 else 'help'} not working properly"


class TestWorkflowIntegration:
    """Test complete workflow scenarios."""
    
    def test_workflow_patterns_exist(self):
        """Verify predefined workflows are available."""
        orchestrate_path = Path("scripts/orchestrate.sh")
        content = orchestrate_path.read_text()
        
        workflows = [
            "workflow",
            "ml-workflow", 
            "deployment-workflow",
            "product-workflow"
        ]
        
        for workflow in workflows:
            assert f'"{workflow}"' in content, f"Workflow {workflow} not found"
    
    def test_parallel_execution_syntax(self):
        """Verify parallel execution command structure."""
        orchestrate_path = Path("scripts/orchestrate.sh")
        content = orchestrate_path.read_text()
        
        # Check for parallel execution with & operator
        assert "&" in content, "Parallel execution not implemented"
        assert "wait" in content, "Wait for parallel processes not implemented"
    
    def test_custom_orchestration_parsing(self):
        """Verify custom orchestration can parse agent:task format."""
        orchestrate_path = Path("scripts/orchestrate.sh")
        content = orchestrate_path.read_text()
        
        # Check for IFS splitting on colon
        assert "IFS=':'" in content, "Task parsing not implemented correctly"
        assert "read -r agent task_desc" in content, "Agent/task splitting not implemented"