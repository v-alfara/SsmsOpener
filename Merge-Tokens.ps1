<#
.SYNOPSIS
Replaces tokens in a block of text with a specified value.
.DESCRIPTION
Replaces tokens in a block of text with a specified value.
In tamplete token sould be placed inside double `#` ( ex: ##Token-Name## )

Adapted based on https://github.com/craibuc/PsTokens/blob/master/Merge-Tokens.ps1
.PARAMETER template
The block of text that contains text and tokens to be replaced.
.PARAMETER tokens
Token name/value hashtable.
.EXAMPLE
Get-Content .\template.tmpl | Merge-Tokens -tokens @{verb: 'beer'; noun: 'question'} |  Out-File -filepath .\target.txt

Pass template to function via pipeline.
.\template.tmpl
to ##verb## or not to ##verb## that is the ##noun## ##mark##
.\target.txt
to beer or not to beer that is the question ##mark##
#>
function Merge-Tokens() {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [String] $template,

        [Parameter(Mandatory = $true)]
        [HashTable] $tokens
    ) 

    begin { Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin" }

    process {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Process" 

        try {

            [regex]::Replace( $template, '##(?<tokenName>[\w\.]+)##', {
                    # ##TOKEN##
                    param($match)

                    $tokenName = $match.Groups['tokenName'].Value
                    Write-Debug $tokenName
              
                    $tokenValue = Invoke-Expression "`$tokens.$tokenName"                    

                    if ($tokenValue) {
                        Write-Debug $tokenValue
                        # there was a value; return it
                        return $tokenValue
                    } 
                    else {
                        Write-Debug 'non-matching token; return token'
                        # non-matching token; return token
                        return $match
                    }
                })

        }
        catch {
            Write-Error $_
        }

    }

    end { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }
} 