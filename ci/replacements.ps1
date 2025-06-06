
$replacementTablePath = Join-Path $PSScriptRoot "Replacements.json"
if (-not (Test-Path $replacementTablePath)) {
    Write-Error "Replacement table file not found: $($replacementTablePath). Aborting."
    exit 1
}

try {
    $replacementTable = Get-Content -Path $replacementTablePath -Raw | ConvertFrom-Json
    foreach ($item in $replacementTable) {
		while ($item.NewString -match '\{\{([A-Za-z0-9_]+)\}\}') {
			$envVarValue = Get-Item -Path "Env:\$($matches[1])" -ErrorAction SilentlyContinue
			if ($null -eq $envVarValue) {
                Write-Warning "Environment variable '$($matches[1])' found to use to update file '$($item.FilePath)' but is not set. Using empty string for replacement. Consider setting it in your pipeline."
                $envVarValue = ""
            } else {
				$envVarValue = $envVarValue.Value
			}
			$item.NewString = $item.NewString.Replace("{{$($matches[1])}}", $envVarValue)
		}
		
		(Get-Content $item.FilePath -Raw) -replace $item.OldString, $item.NewString | Set-Content $item.FilePath
	}
}
catch {
    Write-Error "An error occurred while loading or parsing the replacement table from JSON: $($_.Exception.Message)"
    exit 1
}