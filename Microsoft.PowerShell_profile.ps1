# Key Bindings

Set-PSReadLineKeyHandler -Chord Ctrl+Spacebar -Function AcceptSuggestion

# Completion

gh completion --shell powershell | Out-String | Invoke-Expression # GitHub CLI
Import-Module posh-git # Git

# Functions

function New-Password {
    <#
    .SYNOPSIS
    Creates a new random password.
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [PSDefaultValue()]
        [uint] $Entropy = 256,
        [switch] $WithSymbols
    )

    $Ascii = "`u{0000}".."`u{007F}"
    $Digits = $Ascii | Where-Object { [System.Char]::IsDigit($_) }
    $Letters = $Ascii | Where-Object { [System.Char]::IsLetter($_) }
    $Symbols = $Ascii | Where-Object { [System.Char]::IsPunctuation($_) -or [System.Char]::IsSymbol($_) }

    $Alphabet = $Digits + $Letters
    if ($WithSymbols) {
        $Alphabet += $Symbols
    }

    $Length = [Math]::Ceiling($Entropy / [Math]::Log2($Alphabet.Count))
    $Password = 1..$Length | ForEach-Object { $Alphabet | Get-SecureRandom } | Join-String

    $Password
}
