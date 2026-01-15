---
name: ln-512-manual-tester
description: Performs manual testing of Story AC via executable bash scripts saved to tests/manual/. Creates reusable test suites per Story. Worker for ln-510.
---

# Manual Tester

Manually verifies Story AC on running code and reports structured results for the quality gate.

## Purpose & Scope
- Create executable test scripts in `tests/manual/` folder of target project.
- Run AC-driven checks via bash/curl (API) or puppeteer (UI).
- Save scripts permanently for regression testing (not temp files).
- Document results in Linear with pass/fail per AC and script path.
- No status changes or task creation.

## Test Design Principles

### 1. Fail-Fast - No Silent Failures

**CRITICAL:** Tests MUST return 1 (fail) immediately when any criterion is not met.

**Never use:** `print_status "WARN" + return 0` for validation failures, graceful degradation without explicit flags, silent fallbacks that hide errors.

**Exceptions (WARN is OK):** Informational warnings that don't affect correctness, optional features (with clear justification in comments), infrastructure issues (e.g., missing Nginx in dev environment).

### 2. Expected-Based Testing - The Golden Standard

**CRITICAL:** Tests MUST compare actual results against **expected reference files**, not apply heuristics or algorithmic checks.

**Directory structure:**
```
tests/manual/NN-feature/
├── samples/               # Input files
├── expected/              # Expected output files (REQUIRED!)
│   └── {base_name}_{source_lang}-{target_lang}.{ext}
└── test-*.sh
```

**Heuristics acceptable ONLY for:** dynamic/non-deterministic data (timestamps, UUIDs, tokens - normalize before comparison; JSON with unordered keys - use `jq --sort-keys`).

### 3. Results Storage

Test results saved to `tests/manual/results/` (persistent, in .gitignore). Named: `result_{ac_name}.{ext}` or `response_{ac_name}.json`. Inspectable after test completion for debugging.

### 4. Expected File Generation

To create expected files:
1. Run test with current implementation
2. Review output in `results/` folder
3. If correct: copy to `expected/` folder with proper naming
4. If incorrect: fix implementation first, then copy

**IMPORTANT:** Never blindly copy results to expected. Always validate correctness first.

## Workflow

### Phase 1: Setup tests/manual structure
1) **Read `docs/project/runbook.md`** — get Docker commands, API base URL, test prerequisites, environment setup
2) Check if `tests/manual/` folder exists in project root
3) If missing, create structure:
   - `tests/manual/config.sh` — shared configuration (BASE_URL, helpers, colors)
   - `tests/manual/README.md` — folder documentation (see README.md template below)
   - `tests/manual/test-all.sh` — master script to run all test suites (see test-all.sh template below)
   - `tests/manual/results/` — folder for test outputs (add to `.gitignore`)
4) Add `tests/manual/results/` to project `.gitignore` if not present
5) If exists, read existing `config.sh` to reuse settings (BASE_URL, tokens)

### Phase 2: Create Story test script
1) Fetch Story, parse AC into Given/When/Then list (3-5 expected)
   - **Check for research comment** (from ln-511-test-researcher) — incorporate findings into test cases
2) Detect API vs UI (API → curl, UI → puppeteer)
3) Create test folder structure:
   - `tests/manual/{NN}-{story-slug}/samples/` — input files (if needed)
   - `tests/manual/{NN}-{story-slug}/expected/` — expected output files (REQUIRED for deterministic tests)
4) Generate test script: `tests/manual/{NN}-{story-slug}/test-{story-slug}.sh`
   - Use appropriate template: TEMPLATE-api-endpoint.sh (direct calls) or TEMPLATE-document-format.sh (async jobs)
   - Header: Story ID, AC list, prerequisites
   - Test function per AC + edge/error cases
   - **diff-based validation** against expected files (PRIMARY)
   - Results saved to `tests/manual/results/`
   - Summary table with timing
5) Make script executable (`chmod +x`)

### Phase 2.5: Update Documentation
1) Update `tests/manual/README.md`:
   - Add new test to "Available Test Suites" table
   - Include Story ID, AC covered, run command
2) Update `tests/manual/test-all.sh`:
   - Add call to new script in SUITES array
   - Maintain execution order (00-setup first, then numbered suites)

### Phase 3: Execute and report
1) Rebuild Docker containers (no cache), ensure healthy
2) Run generated script, capture output
3) Parse results (pass/fail counts)
4) Post Linear comment with:
   - AC matrix (pass/fail per AC)
   - Script path: `tests/manual/{NN}-{story-slug}/test-{story-slug}.sh`
   - Rerun command: `cd tests/manual && ./{NN}-{story-slug}/test-{story-slug}.sh`

## Critical Rules
- Scripts saved to project `tests/manual/`, NOT temp files.
- Rebuild Docker before testing; fail if rebuild/run unhealthy.
- Keep language of Story (EN/RU) in script comments and Linear comment.
- No fixes or status changes; only evidence and verdict.
- Script must be idempotent (can rerun anytime).

## Definition of Done
- `tests/manual/` structure exists (config.sh, README.md, test-all.sh, results/ created if missing).
- `tests/manual/results/` added to project `.gitignore`.
- Test script created at `tests/manual/{NN}-{story-slug}/test-{story-slug}.sh`.
- `expected/` folder created with at least 1 expected file per deterministic AC.
- Script uses **diff-based validation** against expected files (not heuristics).
- Script saves results to `tests/manual/results/` for debugging.
- Script is executable and idempotent.
- **README.md updated** with new test suite in "Available Test Suites" table.
- **test-all.sh updated** with call to new script in SUITES array.
- App rebuilt and running; tests executed.
- Verdict and Linear comment posted with script path and rerun command.

## Script Templates

### README.md (created once per project)

```markdown
# Manual Testing Scripts

> **SCOPE:** Bash scripts for manual API testing. Complements automated tests with CLI-based workflows.

## Quick Start

```bash
cd tests/manual
./00-setup/create-account.sh  # (if auth required)
./test-all.sh                 # Run ALL test suites
```

## Prerequisites

- Docker containers running (`docker compose ps`)
- jq installed (`apt-get install jq` or `brew install jq`)

## Folder Structure

```
tests/manual/
├── config.sh          # Shared configuration (BASE_URL, helpers, colors)
├── README.md          # This file
├── test-all.sh        # Run all test suites
├── 00-setup/          # Account & token setup (if auth required)
│   ├── create-account.sh
│   └── get-token.sh
└── {NN}-{topic}/      # Test suites by Story
    └── test-{slug}.sh
```

## Available Test Suites

<!-- Add new test suites here when creating new tests -->

| Suite | Story | AC Covered | Run Command |
|-------|-------|------------|-------------|
| — | — | — | — |

## Adding New Tests

1. Create script in `{NN}-{topic}/test-{slug}.sh`
2. **Update this README** (Available Test Suites table)
3. **Update `test-all.sh`** (add to SUITES array)
```

### test-all.sh (created once per project)

```bash
#!/bin/bash
# =============================================================================
# Run all manual test suites
# =============================================================================
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "=========================================="
echo "Running ALL Manual Test Suites"
echo "=========================================="

check_jq
check_api

# Setup (if exists)
[ -f "$SCRIPT_DIR/00-setup/create-account.sh" ] && "$SCRIPT_DIR/00-setup/create-account.sh"
[ -f "$SCRIPT_DIR/00-setup/get-token.sh" ] && "$SCRIPT_DIR/00-setup/get-token.sh"

# Test suites (add new suites here)
SUITES=(
    # "01-auth/test-auth-flow.sh"
    # "02-translation/test-translation.sh"
)

PASSED=0; FAILED=0
for suite in "${SUITES[@]}"; do
    echo ""
    echo "=========================================="
    echo "Running: $suite"
    echo "=========================================="
    if "$SCRIPT_DIR/$suite"; then
        ((++PASSED))
        print_status "PASS" "$suite"
    else
        ((++FAILED))
        print_status "FAIL" "$suite"
    fi
done

echo ""
echo "=========================================="
echo "TOTAL: $PASSED suites passed, $FAILED failed"
echo "=========================================="
[ $FAILED -eq 0 ] && exit 0 || exit 1
```

### config.sh (created once per project)

```bash
#!/bin/bash
# Shared configuration for manual testing scripts
export BASE_URL="${BASE_URL:-http://localhost:8080}"
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m'

print_status() {
    local status=$1; local message=$2
    case $status in
        "PASS") echo -e "${GREEN}[PASS]${NC} $message" ;;
        "FAIL") echo -e "${RED}[FAIL]${NC} $message" ;;
        "WARN") echo -e "${YELLOW}[WARN]${NC} $message" ;;
        "INFO") echo -e "[INFO] $message" ;;
    esac
}

check_jq() {
    command -v jq &> /dev/null || { echo "Error: jq required"; exit 1; }
}

check_api() {
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/health" 2>/dev/null)
    if [ "$response" != "200" ]; then
        echo "Error: API not reachable at $BASE_URL"
        exit 1
    fi
    print_status "INFO" "API reachable at $BASE_URL"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR
```

### Test Templates (2 types)

**1. TEMPLATE-api-endpoint.sh** - For API endpoint tests (NO async jobs)
- Direct API calls with curl
- Response validation
- Use for: auth-flow, translation, evaluate, SSE streaming

**2. TEMPLATE-document-format.sh** - For document/file processing tests (WITH async jobs)
- Upload → poll → download workflow
- diff-based validation against expected files
- Use for: XLIFF, CSV, JSON, HTML, binary documents

**Quick start:**
```bash
cp TEMPLATE-api-endpoint.sh {NN}-feature/test-{feature}.sh      # Endpoint tests
cp TEMPLATE-document-format.sh {NN}-feature/test-{format}.sh    # Document tests
```

### TEMPLATE-api-endpoint.sh

```bash
#!/bin/bash
# =============================================================================
# {STORY-ID}: {Story Title} (endpoint test)
# =============================================================================
# AC tested: AC1, AC2, AC3...
# Prerequisites: Docker running, jq installed
# Usage: ./test-{feature}.sh
# =============================================================================

set -e
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$THIS_DIR/../config.sh"

check_jq
check_api
setup_auth  # If auth required

# Directories
RESULTS_DIR="$THIS_DIR/../results"
EXPECTED_DIR="$THIS_DIR/expected"
mkdir -p "$RESULTS_DIR"

# Timing
START_TIME=$(date +%s)
echo "Started at $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Test counters
TOTAL=0
PASSED=0
FAILED=0
declare -a TEST_NAMES
declare -a TEST_DURATIONS
declare -a TEST_STATUSES

# =============================================================================
# Helpers
# =============================================================================
call_endpoint() {
    local endpoint=$1
    shift
    curl -s -w "\n%{http_code}" "$BASE_URL$endpoint" \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        "$@"
}

run_test() {
    local name="$1" func="$2"
    ((++TOTAL))

    local test_start=$(date +%s)
    echo ""
    echo "=========================================="
    echo "TEST $TOTAL: $name"
    echo "=========================================="

    if $func; then
        ((++PASSED))
        TEST_STATUSES+=("PASS")
        print_status "PASS" "$name"
    else
        ((++FAILED))
        TEST_STATUSES+=("FAIL")
        print_status "FAIL" "$name"
    fi

    local test_end=$(date +%s)
    local duration=$((test_end - test_start))
    TEST_NAMES+=("$name")
    TEST_DURATIONS+=("$duration")

    sleep 1
}

# =============================================================================
# AC1: Description
# =============================================================================
test_ac1_description() {
    local full_response=$(call_endpoint "/v1/some-endpoint" -X POST \
        -H "Content-Type: application/json" \
        -d '{"key": "value"}')

    local http_code=$(echo "$full_response" | tail -1)
    local response=$(echo "$full_response" | sed '$d')

    # Strict validation: HTTP code
    if [ "$http_code" != "200" ]; then
        print_status "FAIL" "Expected HTTP 200, got $http_code"
        echo "$response" | jq . 2>/dev/null || echo "$response"
        return 1
    fi

    # Save response for inspection
    echo "$response" > "$RESULTS_DIR/response_ac1.json"

    # Expected-based validation (PRIMARY) OR field validation
    local field=$(echo "$response" | jq -r '.field_name // empty')
    [ -z "$field" ] && { print_status "FAIL" "Missing field_name"; return 1; }

    if [ "$field" == "expected_value" ]; then
        echo "Field matches expected value"
        return 0
    else
        print_status "FAIL" "Expected 'expected_value', got '$field'"
        return 1
    fi
}

# =============================================================================
# Execute Tests
# =============================================================================
run_test "AC1: Description" test_ac1_description
# run_test "AC2: Description" test_ac2_description

# =============================================================================
# Summary with Timing Table
# =============================================================================
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

echo ""
echo "========================================"
echo "SUMMARY"
echo "========================================"
echo "Total:  $TOTAL"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""
echo "Detailed Results:"
printf "%-3s | %-42s | %-8s | %s\n" "#" "Test Name" "Status" "Time (s)"
echo "----+--------------------------------------------+----------+----------"

for i in "${!TEST_NAMES[@]}"; do
    num=$((i + 1))
    name="${TEST_NAMES[$i]}"
    status="${TEST_STATUSES[$i]}"
    duration="${TEST_DURATIONS[$i]}"

    [ ${#name} -gt 42 ] && name="${name:0:39}..."
    printf "%-3d | %-42s | %-8s | %8s\n" "$num" "$name" "$status" "$duration"
done

echo ""
echo "Total execution time: ${TOTAL_DURATION}s"
echo "Completed at $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

[ $FAILED -eq 0 ] && print_status "PASS" "All tests passed!" && exit 0
print_status "FAIL" "$FAILED test(s) failed" && exit 1
```

### TEMPLATE-document-format.sh

```bash
#!/bin/bash
# =============================================================================
# {STORY-ID}: {FORMAT} Format Support
# =============================================================================
# AC tested: AC1, AC2, AC3...
# Prerequisites: Docker running, jq installed
# Usage: ./test-{format}.sh
# =============================================================================

set -e
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$THIS_DIR/../config.sh"

check_jq
check_api
setup_auth

# Directories
SAMPLES_DIR="$THIS_DIR/samples"
RESULTS_DIR="$THIS_DIR/../results"
EXPECTED_DIR="$THIS_DIR/expected"
mkdir -p "$RESULTS_DIR"

# Timing
START_TIME=$(date +%s)
echo "Started at $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Test counters
TOTAL=0
PASSED=0
FAILED=0
declare -a TEST_NAMES
declare -a TEST_DURATIONS
declare -a TEST_STATUSES

# =============================================================================
# Helpers (document workflow)
# =============================================================================

upload_document() {
    local file_path=$1 source_lang=$2 target_lang=$3
    curl -s -w "\n%{http_code}" -X POST "$BASE_URL/v1/documents/translate" \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -F "file=@$file_path" \
        -F "source_lang=$source_lang" \
        -F "target_lang=$target_lang"
}

poll_job() {
    local job_id=$1 max_attempts=${2:-30}
    for ((i=0; i<max_attempts; i++)); do
        local response=$(curl -s "$BASE_URL/v1/jobs/$job_id" \
            -H "Authorization: Bearer $ACCESS_TOKEN")
        local status=$(echo "$response" | jq -r '.status')
        case $status in
            "completed") echo "$response"; return 0 ;;
            "failed") echo "$response"; return 1 ;;
            *) sleep 2 ;;
        esac
    done
    return 1
}

download_result() {
    local job_id=$1 output_file=$2
    curl -s "$BASE_URL/v1/jobs/$job_id/result" \
        -H "Authorization: Bearer $ACCESS_TOKEN" -o "$output_file"
}

run_test() {
    local name="$1" func="$2"
    ((++TOTAL))

    local test_start=$(date +%s)
    echo ""
    echo "=========================================="
    echo "TEST $TOTAL: $name"
    echo "=========================================="

    if $func; then
        ((++PASSED))
        TEST_STATUSES+=("PASS")
        print_status "PASS" "$name"
    else
        ((++FAILED))
        TEST_STATUSES+=("FAIL")
        print_status "FAIL" "$name"
    fi

    local test_end=$(date +%s)
    local duration=$((test_end - test_start))
    TEST_NAMES+=("$name")
    TEST_DURATIONS+=("$duration")

    sleep 2
}

# =============================================================================
# AC1: Basic translation
# =============================================================================
test_ac1_basic_translation() {
    local full_response=$(upload_document "$SAMPLES_DIR/sample.ext" "en" "fr")
    local http_code=$(echo "$full_response" | tail -1)
    local response=$(echo "$full_response" | sed '$d')

    # Strict validation: HTTP 202
    if [ "$http_code" != "202" ]; then
        print_status "FAIL" "Expected HTTP 202, got $http_code"
        echo "$response" | jq . 2>/dev/null || echo "$response"
        return 1
    fi

    local job_id=$(echo "$response" | jq -r '.job_id // empty')
    [ -z "$job_id" ] && { print_status "FAIL" "No job_id"; return 1; }

    # Poll job
    if ! poll_job "$job_id" >/dev/null; then
        print_status "FAIL" "Job failed or timed out"
        return 1
    fi

    # Download result
    local result_file="$RESULTS_DIR/result_ac1.ext"
    download_result "$job_id" "$result_file"

    # Expected-based validation (PRIMARY)
    local expected_file="$EXPECTED_DIR/sample_en-fr.ext"
    if diff -q "$result_file" "$expected_file" > /dev/null 2>&1; then
        echo "Output matches expected"
        return 0
    else
        print_status "FAIL" "Output differs from expected"
        echo ""
        echo "Expected (first 20 lines):"
        head -20 "$expected_file"
        echo ""
        echo "Actual (first 20 lines):"
        head -20 "$result_file"
        echo ""
        echo "Diff (first 30 lines):"
        diff "$expected_file" "$result_file" | head -30 || true
        return 1
    fi
}

# =============================================================================
# Execute Tests
# =============================================================================
run_test "AC1: Basic translation" test_ac1_basic_translation
# run_test "AC2: Edge case" test_ac2_edge_case

# =============================================================================
# Summary with Timing Table
# =============================================================================
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

echo ""
echo "========================================"
echo "SUMMARY"
echo "========================================"
echo "Total:  $TOTAL"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""
echo "Detailed Results:"
printf "%-3s | %-42s | %-8s | %s\n" "#" "Test Name" "Status" "Time (s)"
echo "----+--------------------------------------------+----------+----------"

for i in "${!TEST_NAMES[@]}"; do
    num=$((i + 1))
    name="${TEST_NAMES[$i]}"
    status="${TEST_STATUSES[$i]}"
    duration="${TEST_DURATIONS[$i]}"

    [ ${#name} -gt 42 ] && name="${name:0:39}..."
    printf "%-3d | %-42s | %-8s | %8s\n" "$num" "$name" "$status" "$duration"
done

echo ""
echo "Total execution time: ${TOTAL_DURATION}s"
echo "Completed at $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

[ $FAILED -eq 0 ] && print_status "PASS" "All tests passed!" && exit 0
print_status "FAIL" "$FAILED test(s) failed" && exit 1
```

## Reference Files
- Script format reference: prompsit-api `tests/manual/` (production example)
- AC format: `shared/templates/test_task_template.md` (or local `docs/templates/` in target project)
- Risk-based context: `ln-513-auto-test-planner/references/risk_based_testing_guide.md`
- Research findings: ln-511-test-researcher creates "## Test Research" comment on Story

---
**Version:** 1.0.0 (Renamed from ln-503, Phase 0 Research moved to ln-511-test-researcher)
**Last Updated:** 2026-01-15
