#!/usr/bin/env python3
"""
Tests for Adaptive Workflow Functionality
Written by: Tester Agent
"""

import subprocess
import os
from pathlib import Path
import pytest
import re


class TestAdaptiveWorkflow:
    """Test the adaptive workflow script functionality."""
    
    @pytest.fixture
    def project_root(self):
        return Path(__file__).parent.parent.parent
    
    def test_adaptive_workflow_exists(self, project_root):
        """Verify adaptive workflow script exists and is executable."""
        script_path = project_root / "scripts/adaptive-workflow.sh"
        assert script_path.exists(), "adaptive-workflow.sh not found"
        assert os.access(script_path, os.X_OK), "adaptive-workflow.sh not executable"
    
    def test_adaptive_workflow_help(self, project_root):
        """Test that help is shown when no arguments provided."""
        result = subprocess.run(
            ["./scripts/adaptive-workflow.sh"],
            cwd=project_root,
            capture_output=True,
            text=True
        )
        
        assert "Usage:" in result.stdout
        assert "adaptive" in result.stdout
        assert "continuous" in result.stdout
    
    def test_quality_gates_present(self, project_root):
        """Verify quality gates are implemented in the workflow."""
        with open(project_root / "scripts/adaptive-workflow.sh", "r") as f:
            content = f.read()
        
        # Check for quality gate function
        assert "function quality_gate()" in content
        assert "Quality Gate:" in content
        
        # Check for multiple quality gates
        quality_gates = re.findall(r"quality_gate\s+\"([^\"]+)\"", content)
        assert len(quality_gates) >= 3, "Should have at least 3 quality gates"
        
        expected_gates = ["Design Validation", "Code Coverage", "Security Scan"]
        for gate in expected_gates:
            assert gate in quality_gates, f"Missing quality gate: {gate}"
    
    def test_review_checkpoints(self, project_root):
        """Verify review checkpoints are implemented."""
        with open(project_root / "scripts/adaptive-workflow.sh", "r") as f:
            content = f.read()
        
        # Check for review checkpoint function
        assert "function review_checkpoint()" in content
        assert "Review Checkpoint:" in content
        
        # Check that reviews can fail and add steps
        assert "Review found issues" in content
        assert "add_remediation_steps" in content
    
    def test_adaptive_behavior(self, project_root):
        """Test that workflow can adapt by adding steps."""
        with open(project_root / "scripts/adaptive-workflow.sh", "r") as f:
            content = f.read()
        
        # Check for remediation step addition
        assert "function add_remediation_steps()" in content
        assert "ADDITIONAL_STEPS=" in content
        
        # Verify different remediation types
        remediation_types = ["architecture", "implementation", "testing", "security"]
        for rtype in remediation_types:
            assert f'"{rtype}"' in content, f"Missing remediation for: {rtype}"
    
    def test_continuous_review_workflow(self, project_root):
        """Test continuous review workflow option."""
        with open(project_root / "scripts/adaptive-workflow.sh", "r") as f:
            content = f.read()
        
        assert "function continuous_review_workflow()" in content
        assert "Every step is reviewed before proceeding" in content
        
        # Check that it can dynamically add steps
        assert "steps+=(" in content
        assert "Fix review issues" in content
    
    def test_orchestrate_integration(self, project_root):
        """Verify orchestrate.sh references adaptive workflow."""
        with open(project_root / "scripts/orchestrate.sh", "r") as f:
            content = f.read()
        
        # Check that orchestrate mentions adaptive workflow
        assert "adaptive-workflow.sh" in content
        assert "adaptive workflows with dynamic quality gates" in content
    
    def test_workflow_has_qa_gates(self, project_root):
        """Test that standard workflow includes QA gates."""
        with open(project_root / "scripts/orchestrate.sh", "r") as f:
            content = f.read()
        
        # Find the workflow section
        workflow_section = re.search(r'"workflow"\).*?;;', content, re.DOTALL)
        assert workflow_section is not None
        
        workflow_content = workflow_section.group()
        
        # Check for quality gates
        assert "Quality Gate:" in workflow_content
        assert "Architecture Review" in workflow_content
        assert "Code Review" in workflow_content
        assert "Test Results Review" in workflow_content
        assert "Documentation Review" in workflow_content
    
    def test_reviewer_always_suggested(self, project_root):
        """Verify reviewer is always included in analysis."""
        result = subprocess.run(
            ["./scripts/orchestrate.sh", "analyze", "build a feature"],
            cwd=project_root,
            capture_output=True,
            text=True
        )
        
        assert "Reviewer Agent: For continuous quality checks (ALWAYS)" in result.stdout


class TestQAIntegration:
    """Test that QA is integrated throughout the system."""
    
    def test_all_workflows_have_review_steps(self):
        """Ensure all workflow types include review steps."""
        orchestrate_path = Path("scripts/orchestrate.sh")
        content = orchestrate_path.read_text()
        
        workflows = ["workflow", "ml-workflow", "deployment-workflow", "product-workflow"]
        
        for workflow in workflows:
            # Find workflow section
            pattern = f'"{workflow}"\).*?;;'
            match = re.search(pattern, content, re.DOTALL)
            assert match is not None, f"Workflow {workflow} not found"
            
            workflow_content = match.group()
            # Each workflow should have review/quality steps
            assert "review" in workflow_content.lower() or "Review" in workflow_content