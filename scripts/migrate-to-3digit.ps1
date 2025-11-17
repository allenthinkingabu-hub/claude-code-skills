# Migration script: 2-digit to 3-digit skill numbering
# Author: Claude Code
# Date: 2025-11-16

$ErrorActionPreference = "Stop"

# Mapping table: old -> new
$mapping = @{
    # Story Workflow (00-59 -> 300-359)
    'ln-00-story-pipeline' = 'ln-300-story-pipeline'
    'ln-10-story-decomposer' = 'ln-310-story-decomposer'
    'ln-11-task-creator' = 'ln-311-task-creator'
    'ln-12-task-replanner' = 'ln-312-task-replanner'
    'ln-20-story-validator' = 'ln-320-story-validator'
    'ln-21-guide-creator' = 'ln-321-guide-creator'
    'ln-22-adr-creator' = 'ln-322-adr-creator'
    'ln-23-manual-creator' = 'ln-323-manual-creator'
    'ln-30-story-executor' = 'ln-330-story-executor'
    'ln-31-task-executor' = 'ln-331-task-executor'
    'ln-32-task-reviewer' = 'ln-332-task-reviewer'
    'ln-33-task-rework' = 'ln-333-task-rework'
    'ln-34-test-executor' = 'ln-334-test-executor'
    'ln-40-story-quality-gate' = 'ln-340-story-quality-gate'
    'ln-41-code-quality-checker' = 'ln-341-code-quality-checker'
    'ln-42-regression-checker' = 'ln-342-regression-checker'
    'ln-43-manual-tester' = 'ln-343-manual-tester'
    'ln-50-story-test-planner' = 'ln-350-story-test-planner'

    # Documentation (60-69 -> 110-119)
    'ln-60-docs-system' = 'ln-110-docs-system'
    'ln-61-docs-creator' = 'ln-111-docs-creator'
    'ln-62-html-builder' = 'ln-112-html-builder'
    'ln-63-docs-updater' = 'ln-113-docs-updater'
    'ln-64-docs-structure-validator' = 'ln-114-docs-structure-validator'

    # Epic Planning (70-79 -> 210-219)
    'ln-70-epic-creator' = 'ln-210-epic-creator'
    'ln-71-story-manager' = 'ln-211-story-manager'
}

Write-Host "=== Skill Renumbering Migration Script ===" -ForegroundColor Cyan
Write-Host "Total skills to migrate: $($mapping.Count)" -ForegroundColor Yellow
Write-Host ""

# Phase 1: Rename directories
Write-Host "Phase 1: Renaming directories..." -ForegroundColor Green

$renamedDirs = 0
foreach ($old in $mapping.Keys | Sort-Object) {
    $new = $mapping[$old]
    $oldPath = Join-Path $PSScriptRoot "..\$old"
    $newPath = Join-Path $PSScriptRoot "..\$new"

    if (Test-Path $oldPath) {
        Write-Host "  $old -> $new" -ForegroundColor White
        Rename-Item -Path $oldPath -NewName $new -ErrorAction Stop
        $renamedDirs++
    } else {
        Write-Host "  [SKIP] $old (not found)" -ForegroundColor Yellow
    }
}

Write-Host "  Renamed: $renamedDirs directories" -ForegroundColor Green
Write-Host ""

# Phase 2: Update all file references
Write-Host "Phase 2: Updating file references..." -ForegroundColor Green

# Get all files that might contain skill references
$filesToUpdate = @(
    Get-ChildItem -Path (Join-Path $PSScriptRoot "..") -Filter "*.md" -Recurse |
        Where-Object { $_.FullName -notmatch '\\node_modules\\' -and $_.FullName -notmatch '\\.git\\' }

    Get-ChildItem -Path (Join-Path $PSScriptRoot "..") -Filter "diagram.html" -Recurse |
        Where-Object { $_.FullName -notmatch '\\node_modules\\' -and $_.FullName -notmatch '\\.git\\' }
)

$totalFiles = $filesToUpdate.Count
$updatedFiles = 0
$totalReplacements = 0

Write-Host "  Files to scan: $totalFiles" -ForegroundColor Yellow

foreach ($file in $filesToUpdate) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    $fileReplacements = 0

    # Replace each old skill name with new one
    # Sort by length (longest first) to avoid partial replacements
    foreach ($old in ($mapping.Keys | Sort-Object -Property Length -Descending)) {
        $new = $mapping[$old]

        # Pattern 1: Directory paths (ln-XX-name/)
        $pattern1 = [regex]::Escape("$old/")
        $replacement1 = "$new/"
        if ($content -match $pattern1) {
            $content = $content -replace $pattern1, $replacement1
            $fileReplacements++
        }

        # Pattern 2: SKILL.md frontmatter (name: ln-XX-name)
        $pattern2 = "name:\s+$([regex]::Escape($old))"
        $replacement2 = "name: $new"
        if ($content -match $pattern2) {
            $content = $content -replace $pattern2, $replacement2
            $fileReplacements++
        }

        # Pattern 3: Skill tool invocations (ln-XX-name)
        # Match word boundaries to avoid partial replacements
        $pattern3 = "\b$([regex]::Escape($old))\b"
        $replacement3 = $new
        if ($content -match $pattern3) {
            $before = ($content -split $pattern3).Count - 1
            $content = $content -replace $pattern3, $replacement3
            $after = ($content -split [regex]::Escape($new)).Count - 1
            if ($after -gt $before) {
                $fileReplacements++
            }
        }

        # Pattern 4: Markdown links [text](ln-XX-name/...)
        $pattern4 = "\]\($([regex]::Escape($old))/"
        $replacement4 = "]($new/"
        if ($content -match $pattern4) {
            $content = $content -replace $pattern4, $replacement4
            $fileReplacements++
        }
    }

    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $updatedFiles++
        $totalReplacements += $fileReplacements
        Write-Host "  Updated: $($file.Name) ($fileReplacements replacements)" -ForegroundColor White
    }
}

Write-Host "  Updated: $updatedFiles files" -ForegroundColor Green
Write-Host "  Total replacements: $totalReplacements" -ForegroundColor Green
Write-Host ""

# Phase 3: Summary
Write-Host "=== Migration Complete ===" -ForegroundColor Cyan
Write-Host "Directories renamed: $renamedDirs / $($mapping.Count)" -ForegroundColor $(if ($renamedDirs -eq $mapping.Count) { 'Green' } else { 'Yellow' })
Write-Host "Files updated: $updatedFiles" -ForegroundColor Green
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
Write-Host ""

# Verification
Write-Host "Phase 4: Verification..." -ForegroundColor Green
$errors = @()

foreach ($new in $mapping.Values | Sort-Object) {
    $newPath = Join-Path $PSScriptRoot "..\$new"
    if (-not (Test-Path $newPath)) {
        $errors += "Missing directory: $new"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "  ERRORS FOUND:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  - $error" -ForegroundColor Red
    }
} else {
    Write-Host "  All directories verified successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review changes in your IDE" -ForegroundColor White
Write-Host "  2. Update CHANGELOG.md manually" -ForegroundColor White
Write-Host "  3. Test skill invocations" -ForegroundColor White
Write-Host "  4. Create git commit when ready" -ForegroundColor White
