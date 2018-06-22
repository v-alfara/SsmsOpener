Write-Debug "Importing module SsmsOpener"

if(!$SsmsOpenerTemplateFolder){
	$SsmsOpenerTemplateFolder = Join-Path (Split-Path -Path $(Get-PSCallStack)[0].ScriptName -Parent) "templates"
}

if(!$SsmsOpenerGeneratedFolder){
	$SsmsOpenerGeneratedFolder = Join-Path (Split-Path -Path $(Get-PSCallStack)[0].ScriptName -Parent) "generated"
}

Write-Debug "SsmsOpenerGeneratedFolder:" $SsmsOpenerGeneratedFolder
Write-Debug "SsmsOpenerTemplateFolder:" $SsmsOpenerTemplateFolder

#
# load (dot-source) *.PS1 files
#
Get-ChildItem "$PSScriptRoot\*.ps1" | 
    Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | % {. $_}


#export module member
#common module function and variables
Export-ModuleMember -Variable SsmsOpenerTemplateFolder, SsmsOpenerGeneratedFolder
Export-ModuleMember -Function OpenMicrosoftSQLServerManagementStudio, CreateSqlAndOpenSsms

#KPI team function and alias 
Export-ModuleMember -Function OpenSsmsForKPIIncident 
Export-ModuleMember -Alias ssms-kpi

