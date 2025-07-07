#!/usr/bin/env python3
"""
Prompt Regression Testing

Validates that agent prompts maintain expected functionality
even as Claude models evolve. This helps catch breaking changes.
"""

import hashlib
import json
from pathlib import Path
from datetime import datetime
import sys


class PromptValidator:
    """Validate prompt consistency and structure."""
    
    def __init__(self):
        self.commands_dir = Path(".claude/commands")
        self.baseline_file = Path("tests/template/prompt_baseline.json")
    
    def generate_prompt_signatures(self):
        """Generate signatures for all prompts."""
        signatures = {}
        
        for command_file in self.commands_dir.glob("*.md"):
            content = command_file.read_text()
            agent = command_file.stem
            
            # Extract key sections
            signatures[agent] = {
                "file": str(command_file),
                "size": len(content),
                "hash": hashlib.sha256(content.encode()).hexdigest()[:16],
                "has_role": "## Role" in content or "You are" in content,
                "has_responsibilities": "Responsibilities" in content,
                "has_coordination": "coordination" in content.lower(),
                "sections": self._extract_sections(content),
                "timestamp": datetime.now().isoformat()
            }
        
        return signatures
    
    def _extract_sections(self, content):
        """Extract markdown section headers."""
        import re
        sections = re.findall(r'^#{1,3}\s+(.+)$', content, re.MULTILINE)
        return sections
    
    def create_baseline(self):
        """Create a baseline for prompt comparison."""
        signatures = self.generate_prompt_signatures()
        
        self.baseline_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self.baseline_file, 'w') as f:
            json.dump(signatures, f, indent=2)
        
        print(f"✅ Created prompt baseline with {len(signatures)} agents")
        return signatures
    
    def validate_against_baseline(self):
        """Validate current prompts against baseline."""
        if not self.baseline_file.exists():
            print("⚠️  No baseline found. Creating initial baseline...")
            return self.create_baseline()
        
        with open(self.baseline_file, 'r') as f:
            baseline = json.load(f)
        
        current = self.generate_prompt_signatures()
        
        issues = []
        
        # Check for missing agents
        for agent in baseline:
            if agent not in current:
                issues.append(f"❌ Missing agent: {agent}")
        
        # Check for new agents
        for agent in current:
            if agent not in baseline:
                issues.append(f"✨ New agent detected: {agent}")
        
        # Check for significant changes
        for agent in baseline:
            if agent in current:
                base = baseline[agent]
                curr = current[agent]
                
                # Check structural changes
                if base["has_role"] != curr["has_role"]:
                    issues.append(f"⚠️  {agent}: Role definition changed")
                
                if base["has_responsibilities"] != curr["has_responsibilities"]:
                    issues.append(f"⚠️  {agent}: Responsibilities section changed")
                
                # Check size changes (>20% difference)
                size_change = abs(curr["size"] - base["size"]) / base["size"]
                if size_change > 0.2:
                    issues.append(f"📏 {agent}: Significant size change ({size_change:.1%})")
                
                # Check section changes
                base_sections = set(base["sections"])
                curr_sections = set(curr["sections"])
                
                removed = base_sections - curr_sections
                added = curr_sections - base_sections
                
                if removed:
                    issues.append(f"➖ {agent}: Removed sections: {removed}")
                if added:
                    issues.append(f"➕ {agent}: Added sections: {added}")
        
        return issues
    
    def update_baseline(self):
        """Update the baseline with current prompts."""
        signatures = self.generate_prompt_signatures()
        
        with open(self.baseline_file, 'w') as f:
            json.dump(signatures, f, indent=2)
        
        print(f"✅ Updated baseline for {len(signatures)} agents")


def main():
    """Run prompt validation."""
    validator = PromptValidator()
    
    if len(sys.argv) > 1 and sys.argv[1] == "--update":
        validator.update_baseline()
    else:
        issues = validator.validate_against_baseline()
        
        if issues:
            print("\n🔍 Prompt Validation Results:")
            for issue in issues:
                print(f"  {issue}")
            
            # Return non-zero if there are breaking changes
            breaking = [i for i in issues if i.startswith("❌")]
            if breaking:
                sys.exit(1)
        else:
            print("✅ All prompts match baseline")


if __name__ == "__main__":
    main()