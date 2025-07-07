# Repository Cleanup Plan

## Current State Analysis

### Scripts Directory (33 files)
- 15 nearly identical launch-*.sh scripts
- Multiple test/demo scripts mixed with core functionality
- Several potentially redundant audit/workflow scripts
- No clear organization or categorization

### Test Directory
- Tests are actually well-organized and valid
- Clear separation between template tests and example tests
- Good structure with unit/integration/e2e directories

## Cleanup Actions

### 1. Consolidate Launch Scripts (HIGH PRIORITY)
**Problem**: 15 nearly identical scripts doing the same thing
**Solution**: Create single `launch-agent.sh` script

### 2. Move Test/Demo Scripts
**Files to move**:
- `test-orchestration.sh` → `tests/scripts/`
- `simulate-audit.sh` → `tests/scripts/`
- `validate-template.sh` → Already belongs in scripts/ as it validates the template

### 3. Consolidate Orchestration Scripts
**Current**: 3 separate orchestration scripts
**Solution**: Merge into single `orchestrate.sh` with modes:
- `orchestrate.sh adaptive` - Adaptive workflows
- `orchestrate.sh parallel` - Parallel execution
- `orchestrate.sh meeting` - Collaborative meetings

### 4. Remove Redundant Scripts
**Candidates for removal**:
- `audit-summary.sh` - Functionality covered by other scripts
- `full-audit.sh` - Just calls orchestrate-parallel.sh

### 5. Organize Remaining Scripts
```
scripts/
├── orchestrate.sh          # All orchestration modes
├── launch-agent.sh         # Universal agent launcher
├── setup-agents.sh         # Initial setup
├── taskboard-helper.py     # Taskboard management
├── agent-task.sh          # Agent task wrapper
├── validate-template.sh    # Template validation
└── security/
    ├── secure-temp.sh
    └── security-fixes.sh
```

## Implementation Order

1. Create consolidated `launch-agent.sh`
2. Remove individual launch scripts
3. Move test/demo scripts to tests/
4. Merge orchestration scripts
5. Remove redundant scripts
6. Update documentation

## Expected Outcome
- Reduce from 33 scripts to ~8-10 organized scripts
- Clearer purpose for each script
- Better maintainability
- Same functionality with less confusion