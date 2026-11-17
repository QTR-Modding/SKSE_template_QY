param(
    [Parameter(Mandatory = $true)]
    [string] $Dll,
    [string] $Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

if ($Configuration -notin 'Release', 'RelWithDebInfo', 'MinSizeRel') {
    return
}

$bytes = [IO.File]::ReadAllBytes($Dll)
$windowsPath = '(?i)(?<![\w:])(?:[a-z]:[\\/](?![\\/])|[\\/]{2}(?:\?[\\/]UNC[\\/])?[\w.-]+[\\/])[^<>:"|?*\x00-\x1f\x7f\ufffd]*(?=\x00|:[0-9]+\x00)'
$paths = @(
    [Text.Encoding]::UTF8.GetString($bytes)
    [Text.Encoding]::Unicode.GetString($bytes)
    [Text.Encoding]::Unicode.GetString($bytes, 1, $bytes.Length - 1)
) | ForEach-Object {
    foreach ($match in [regex]::Matches($_, $windowsPath)) {
        $match.Value
    }
} | Sort-Object -Unique

if ($paths) {
    throw "Absolute Windows paths found in $Dll$([Environment]::NewLine)$($paths -join [Environment]::NewLine)"
}
