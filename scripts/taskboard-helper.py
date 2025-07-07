#!/usr/bin/env python3
"""
Taskboard Helper - A more robust way to update the taskboard
"""

import sys
import os
import re
from datetime import datetime
from pathlib import Path

TASKBOARD_PATH = Path(".claude/tasks/taskboard.md")

def read_taskboard():
    """Read the current taskboard content."""
    return TASKBOARD_PATH.read_text()

def write_taskboard(content):
    """Write updated content to taskboard."""
    # Create backup
    backup_path = TASKBOARD_PATH.with_suffix('.md.bak')
    TASKBOARD_PATH.rename(backup_path)
    
    # Write new content
    TASKBOARD_PATH.write_text(content)
    print(f"✅ Taskboard updated successfully")

def add_task(agent, task_id, description, priority="P2"):
    """Add a new task to the backlog."""
    content = read_taskboard()
    date = datetime.now().strftime("%Y-%m-%d")
    
    new_task = f"""### [{task_id}] {description}
- **Priority**: {priority}
- **Assigned**: @{agent}
- **Created**: {date}
- **Updated**: {date}
- **Status**: Backlog

"""
    
    # Find the right section based on priority
    if priority == "P1":
        section = "### High Priority (P1)"
        placeholder = "_No high priority tasks_"
    elif priority == "P2":
        section = "### Medium Priority (P2)"
        placeholder = "_No medium priority tasks_"
    else:
        section = "### Low Priority (P3)"
        placeholder = "_No low priority tasks_"
    
    # Replace placeholder or add after section header
    if placeholder in content:
        content = content.replace(placeholder, new_task.strip())
    else:
        # Add after section header
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if line.strip() == section:
                lines.insert(i + 1, new_task.strip())
                break
        content = '\n'.join(lines)
    
    write_taskboard(content)
    print(f"📝 Added task {task_id} to {priority} backlog")

def move_task(task_id, new_section):
    """Move a task to a different section."""
    content = read_taskboard()
    date = datetime.now().strftime("%Y-%m-%d")
    
    # Extract task
    task_pattern = rf"### \[{task_id}\].*?(?=###|\n\n|\Z)"
    match = re.search(task_pattern, content, re.DOTALL)
    
    if not match:
        print(f"❌ Task {task_id} not found")
        return
    
    task_content = match.group(0).strip()
    
    # Remove from current location
    content = re.sub(task_pattern, "", content, count=1, flags=re.DOTALL)
    
    # Update task metadata
    task_content = re.sub(r"Updated: \d{4}-\d{2}-\d{2}", f"Updated: {date}", task_content)
    
    # Update status based on section
    status_map = {
        "In Progress": "In Progress",
        "Review": "Review",
        "Testing": "Testing",
        "Recent Completions": "Done"
    }
    
    if new_section in status_map:
        task_content = re.sub(r"Status: \w+", f"Status: {status_map[new_section]}", task_content)
    
    # Find section and add task
    section_pattern = rf"### {new_section}\n"
    if re.search(section_pattern, content):
        # Remove placeholder if exists
        placeholder_map = {
            "In Progress": "_No tasks currently in progress_",
            "Review": "_No tasks currently in review_",
            "Testing": "_No tasks currently in testing_",
            "Recent Completions": "_No recently completed tasks_"
        }
        
        if new_section in placeholder_map:
            placeholder = placeholder_map[new_section]
            if placeholder in content:
                content = content.replace(placeholder, task_content + "\n")
            else:
                # Add after section header
                content = re.sub(section_pattern, f"{section_pattern}{task_content}\n\n", content)
        else:
            content = re.sub(section_pattern, f"{section_pattern}{task_content}\n\n", content)
    
    write_taskboard(content)
    print(f"➡️  Moved task {task_id} to {new_section}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python taskboard-helper.py <action> [args]")
        print("\nActions:")
        print("  add <agent> <task-id> <priority> <description>")
        print("  start <task-id>")
        print("  review <task-id>")
        print("  test <task-id>")
        print("  complete <task-id>")
        print("\nExamples:")
        print("  python taskboard-helper.py add architect ARCH-001 P1 'Design authentication'")
        print("  python taskboard-helper.py start ARCH-001")
        print("  python taskboard-helper.py complete ARCH-001")
        sys.exit(1)
    
    action = sys.argv[1]
    
    if action == "add":
        if len(sys.argv) < 5:
            print("Error: add requires <agent> <task-id> <priority> <description>")
            sys.exit(1)
        agent = sys.argv[2]
        task_id = sys.argv[3]
        priority = sys.argv[4]
        description = ' '.join(sys.argv[5:])
        add_task(agent, task_id, description, priority)
    
    elif action == "start":
        if len(sys.argv) < 3:
            print("Error: start requires <task-id>")
            sys.exit(1)
        move_task(sys.argv[2], "In Progress")
    
    elif action == "review":
        if len(sys.argv) < 3:
            print("Error: review requires <task-id>")
            sys.exit(1)
        move_task(sys.argv[2], "Review")
    
    elif action == "test":
        if len(sys.argv) < 3:
            print("Error: test requires <task-id>")
            sys.exit(1)
        move_task(sys.argv[2], "Testing")
    
    elif action == "complete":
        if len(sys.argv) < 3:
            print("Error: complete requires <task-id>")
            sys.exit(1)
        move_task(sys.argv[2], "Recent Completions")
    
    else:
        print(f"Unknown action: {action}")
        sys.exit(1)

if __name__ == "__main__":
    main()