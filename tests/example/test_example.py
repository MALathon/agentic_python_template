#!/usr/bin/env python3
"""
Example Tests for Template Users

This shows how to structure tests for your Python project.
These are the tests YOU write for YOUR application logic.
"""

import pytest
from pathlib import Path


class TestYourProject:
    """Example test class for your project functionality."""
    
    def test_project_structure(self):
        """Test that your project has expected structure."""
        # Example: Verify your source directory exists
        src_dir = Path("src")
        assert src_dir.exists(), "Source directory not found"
    
    def test_your_feature(self):
        """Example test for your application feature."""
        # This is where you test YOUR code, not the template
        # For example:
        # from src.your_module import your_function
        # result = your_function("input")
        # assert result == "expected output"
        pass
    
    @pytest.mark.integration
    def test_integration_example(self):
        """Example integration test."""
        # Test how your components work together
        # This is YOUR application logic, not agent testing
        pass


class TestYourAPI:
    """Example API tests."""
    
    def test_api_endpoint(self):
        """Example API test."""
        # Test your REST API endpoints
        # Use requests or httpx to test your API
        pass


# Remember: These tests are for YOUR application
# The template validation tests in tests/template/ are only
# for maintaining the agentic template itself