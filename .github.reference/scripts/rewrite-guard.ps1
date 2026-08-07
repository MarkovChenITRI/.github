$ErrorActionPreference = 'Stop'

function Get-HookStatePath {
    param(
        [string]$WorkspaceRoot,
        [string]$SessionId
    )

    $gitDir = Join-Path $WorkspaceRoot '.git'
    $stateDir = Join-Path $gitDir 'copilot-hook-state'

    if (-not (Test-Path $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
    }

    if ([string]::IsNullOrWhiteSpace($SessionId)) {
        $SessionId = 'default-session'
    }

    return Join-Path $stateDir ($SessionId + '.json')
}

function ConvertTo-Hashtable {
    param([object]$InputObject)

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        $dictionary = @{}
        foreach ($key in $InputObject.Keys) {
            $dictionary[$key] = ConvertTo-Hashtable -InputObject $InputObject[$key]
        }
        return $dictionary
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [string])) {
        $items = @()
        foreach ($item in $InputObject) {
            $items += ,(ConvertTo-Hashtable -InputObject $item)
        }
        return $items
    }

    if ($InputObject -is [psobject]) {
        $properties = $InputObject.PSObject.Properties
        if ($properties.Count -gt 0) {
            $dictionary = @{}
            foreach ($property in $properties) {
                $dictionary[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            return $dictionary
        }
    }

    return $InputObject
}

function Read-State {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return [ordered]@{
            frozen = $false
            mode = 'unknown'
            editScope = 'unknown'
            lastPrompt = ''
            updatedAt = ''
        }
    }

    try {
        return (ConvertTo-Hashtable -InputObject (Get-Content -Raw -Path $Path | ConvertFrom-Json))
    }
    catch {
        return [ordered]@{
            frozen = $false
            mode = 'unknown'
            editScope = 'unknown'
            lastPrompt = ''
            updatedAt = ''
        }
    }
}

function Write-State {
    param(
        [string]$Path,
        [hashtable]$State
    )

    $State.updatedAt = [DateTime]::UtcNow.ToString('o')
    $State | ConvertTo-Json -Depth 6 | Set-Content -Path $Path -Encoding UTF8
}

function Get-StringField {
    param(
        [hashtable]$InputObject,
        [string[]]$CandidateKeys
    )

    foreach ($key in $CandidateKeys) {
        if ($InputObject.ContainsKey($key) -and $null -ne $InputObject[$key]) {
            return [string]$InputObject[$key]
        }
    }

    return ''
}

function Get-PromptMode {
    param([string]$Prompt)

    $text = [string]$Prompt
    if ([string]::IsNullOrWhiteSpace($text)) {
        return 'unknown'
    }

    $explicitEdit = $text -match '\u958B\u59CB\u5BE6\u4F5C|start implementation|implement|\u90A3\u5C31\u88DC|\u8ACB\u4FEE\u6539|\u8ACB\u6539|\u76F4\u63A5\u6539|\u91CD\u5BEB|\u66F4\u65B0|\u88DC\u4E0A|\u5BE6\u4F5C|\u4FEE\u6539|\u4FEE\u6B63|\u6539\u6210|\u6539\u5BEB|\u6700\u5C0F\u5E45\u5EA6\u4FEE\u6539|\u5C40\u90E8\u6539\u5BEB|\u5C40\u90E8\u4FEE\u6539|\u76E1\u53EF\u80FD\u4FEE\u6539\u8D8A\u5C11|minimal edit|small edit|local edit|targeted edit|preserve original wording'
    $reviewOrAccountability = $text -match '\u6AA2\u8A0E|\u554F\u8CAC|\u70BA\u4EC0\u9EBC|\u6709\u6C92\u6709|\u662F\u5426|\u504F\u984C|\u5408\u683C|\u4E82\u6539|\u4E82\u8B1B|\u4F60\u5728\u8B1B\u4EC0\u9EBC|\u64DA\u5BE6\u8B1B|review|accountability|why|is it|does it|\?'

    if ($explicitEdit) {
        return 'edit'
    }

    if ($reviewOrAccountability) {
        return 'review'
    }

    return 'unknown'
}

function Get-EditScope {
    param([string]$Prompt)

    $text = [string]$Prompt
    if ([string]::IsNullOrWhiteSpace($text)) {
        return 'unknown'
    }

    $targetedEdit = $text -match '\u6700\u5C0F\u5E45\u5EA6\u4FEE\u6539|\u6700\u5C0F\u5E45\u5EA6|\u5C40\u90E8\u6539\u5BEB|\u5C40\u90E8\u4FEE\u6539|\u53EA\u6539\u9019\u6BB5|\u53EA\u6539\u9019\u53E5|\u53EA\u6539\u9019\u4E00\u6BB5|\u53EA\u6539\u9019\u4E00\u53E5|\u4FDD\u7559\u539F\u672C\u6587\u6848\u908F\u8F2F|\u76E1\u53EF\u80FD\u4FEE\u6539\u8D8A\u5C11|\u76E1\u91CF\u4FDD\u7559\u539F\u672C|minimal edit|small edit|local edit|targeted edit|preserve original wording'
    $broadRewrite = $text -match '\u91CD\u5BEB|\u6574\u9801|\u6574\u4EFD|\u6574\u7D44|\u5168\u90E8\u91CD\u6539|\u5168\u9762\u6539|\u8DE8\u9801|\u4E03\u5927\u6587\u4EF6|\u4E03\u9801|\u6574\u500B\u6587\u4EF6|\u5168\u90E8\u6587\u4EF6|rewrite all|rewrite the whole|entire page|cross-page|broad rewrite'

    if ($targetedEdit) {
        return 'targeted'
    }

    if ($broadRewrite) {
        return 'broad'
    }

    return 'unknown'
}

function Get-IsFrozenSignal {
    param([string]$Prompt)

    return ($Prompt -match '\u5B9A\u7A3F|\u4E0D\u8981\u4E82\u6539|\u5148\u4E0D\u8981\u52D5\u5167\u5BB9|\u4E0D\u8981\u52D5\u5167\u5BB9|\u4E0D\u80FD\u6539|\u5225\u6539')
}

function Get-IsReopenSignal {
    param([string]$Prompt)

    return ($Prompt -match '\u958B\u59CB\u5BE6\u4F5C|start implementation|\u90A3\u5C31\u88DC|\u8ACB\u4FEE\u6539|\u8ACB\u6539|\u76F4\u63A5\u6539|\u91CD\u5BEB|\u66F4\u65B0|\u88DC\u4E0A|\u53EF\u4EE5\u6539|\u91CD\u65B0\u6388\u6B0A')
}

function Get-DeepStrings {
    param([object]$InputObject)

    $values = @()

    if ($null -eq $InputObject) {
        return $values
    }

    if ($InputObject -is [string]) {
        return @([string]$InputObject)
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        foreach ($key in $InputObject.Keys) {
            $values += Get-DeepStrings -InputObject $InputObject[$key]
        }
        return $values
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [string])) {
        foreach ($item in $InputObject) {
            $values += Get-DeepStrings -InputObject $item
        }
        return $values
    }

    if ($InputObject -is [psobject]) {
        foreach ($property in $InputObject.PSObject.Properties) {
            $values += Get-DeepStrings -InputObject $property.Value
        }
    }

    return $values
}

function Get-PatchStats {
    param([hashtable]$EventData)

    $strings = Get-DeepStrings -InputObject $EventData
    $patchText = ''

    foreach ($value in $strings) {
        if ($value -match '\*\*\* Begin Patch') {
            $patchText = $value
            break
        }
    }

    if ([string]::IsNullOrWhiteSpace($patchText)) {
        return [ordered]@{
            fileCount = 0
            changedLineCount = 0
        }
    }

    $fileHeaders = [regex]::Matches($patchText, '(?m)^\*\*\* (?:Update|Add|Delete) File:\s+')
    $changedLines = [regex]::Matches($patchText, '(?m)^[\+\-](?![\+\-])')

    return [ordered]@{
        fileCount = $fileHeaders.Count
        changedLineCount = $changedLines.Count
    }
}

try {
    $rawInput = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($rawInput)) {
        '{}' | Write-Output
        exit 0
    }

    $eventData = ConvertTo-Hashtable -InputObject ($rawInput | ConvertFrom-Json)
    $hookEventName = Get-StringField -InputObject $eventData -CandidateKeys @('hook_event_name', 'hookEventName')
    $workspaceRoot = Get-StringField -InputObject $eventData -CandidateKeys @('cwd')
    $sessionId = Get-StringField -InputObject $eventData -CandidateKeys @('session_id', 'sessionId')

    if ([string]::IsNullOrWhiteSpace($workspaceRoot)) {
        $workspaceRoot = Get-Location | Select-Object -ExpandProperty Path
    }

    $statePath = Get-HookStatePath -WorkspaceRoot $workspaceRoot -SessionId $sessionId
    $state = Read-State -Path $statePath

    switch ($hookEventName) {
        'UserPromptSubmit' {
            $prompt = Get-StringField -InputObject $eventData -CandidateKeys @('prompt', 'user_prompt', 'userPrompt')
            $state.lastPrompt = $prompt
            $state.mode = Get-PromptMode -Prompt $prompt
            $state.editScope = Get-EditScope -Prompt $prompt

            if (Get-IsReopenSignal -Prompt $prompt) {
                $state.frozen = $false
            }
            elseif (Get-IsFrozenSignal -Prompt $prompt) {
                $state.frozen = $true
            }

            Write-State -Path $statePath -State $state
            '{"continue":true}' | Write-Output
            exit 0
        }
        'PreToolUse' {
            $toolName = Get-StringField -InputObject $eventData -CandidateKeys @('tool_name', 'toolName')
            $editTools = @('apply_patch', 'create_file')

            if ($editTools -notcontains $toolName) {
                '{"continue":true}' | Write-Output
                exit 0
            }

            $denyReason = $null
            if ($state.mode -eq 'review') {
                $denyReason = 'Review/accountability turn detected. Answer the judgment request first and get explicit rewrite permission before editing.'
            }
            elseif ($state.frozen) {
                $denyReason = 'Frozen content detected. Do not rewrite until the user explicitly reopens that content for editing.'
            }

            if ($null -eq $denyReason -and $state.editScope -eq 'targeted') {
                if ($toolName -eq 'create_file') {
                    $denyReason = 'Targeted edit permission detected. Read broadly if needed, but do not create new files or expand beyond the cited content without broader authorization.'
                }
                elseif ($toolName -eq 'apply_patch') {
                    $patchStats = Get-PatchStats -EventData $eventData
                    if ($patchStats.fileCount -gt 1) {
                        $denyReason = 'Targeted edit permission detected. You may read the whole context, but the patch must stay within a single cited file unless the user explicitly authorizes a broader rewrite.'
                    }
                    elseif ($patchStats.changedLineCount -gt 120) {
                        $denyReason = 'Targeted edit permission detected. Keep the actual patch minimal and aligned with the original wording; this change is too large for the current authorization.'
                    }
                }
            }

            if ($null -ne $denyReason) {
                @{
                    hookSpecificOutput = @{
                        hookEventName = 'PreToolUse'
                        permissionDecision = 'deny'
                        permissionDecisionReason = $denyReason
                    }
                    systemMessage = $denyReason
                } | ConvertTo-Json -Depth 6 | Write-Output
                exit 0
            }

            '{"continue":true}' | Write-Output
            exit 0
        }
        default {
            '{"continue":true}' | Write-Output
            exit 0
        }
    }
}
catch {
    $message = $_.Exception.Message.Replace('"', '\"')
    Write-Error $message
    exit 2
}
