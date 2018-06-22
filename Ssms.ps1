<#
.SYNOPSIS
Opens script file into Microsoft SQL Server Management Studio and connect to server 
.DESCRIPTION
Opens script  file into Microsoft SQL Server Management Studio and connect to server according to connection string 
.PARAMETER connectionString
ms sql connection string 
.PARAMETER script
path to script file 
.EXAMPLE
OpenMicrosoftSQLServerManagementStudio .\my.sql  "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****"
#>
function OpenMicrosoftSQLServerManagementStudio {
    param(
        [Parameter(Mandatory = $true)]    
        [string] $connectionString,

        [Parameter(Mandatory = $true)]    
        [string] $script
    )

    $sb = New-Object System.Data.Common.DbConnectionStringBuilder
    $sb.set_ConnectionString($connectionString)
    Write-Host  'opening Microsoft SQL Server Management Studio...'
    & ssms $script `
        -S $($sb['data source']) `
        -d $($sb['initial catalog']) `
        -U $($sb['user id']) `
        -P $($sb['password']) 
}

<#
.SYNOPSIS
Create sql script base on template and variables and opens the script into Microsoft SQL Server Management Studio
.PARAMETER connectionString
ms sql connection string 
.PARAMETER sqlTemplateName
Template file should located in the same folder with script and has name `<sqlTemplateName>.sql.tmpl`
.PARAMETER templateVariables
variables for replace tocken into template file
.EXAMPLE
CreateSqlAndOpenSsms  -connectionString "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****" -sqlTemplateName 'kpi_incident' -templateVariables @{'tenantId' = $tenantId; 'typeName' = $typeName}
#>
function CreateSqlAndOpenSsms {
    param(
        [Parameter(Mandatory = $true)]    
        [string] $connectionString,
        
        [Parameter(Mandatory = $true)]    
        [string] $sqlTemplateName,

        [Parameter(Mandatory = $true)]    
        [HashTable] $templateVariables             
    )

    $tempaltePath = Join-Path -Path $SsmsOpenerTemplateFolder -ChildPath $($sqlTemplateName + ".tmpl.sql")
    $sqlPath = Join-Path -Path $SsmsOpenerGeneratedFolder -ChildPath $($sqlTemplateName + ".sql")
    
    Get-Content $tempaltePath | Merge-Tokens -tokens $templateVariables | Out-File -filepath $sqlPath
    OpenMicrosoftSQLServerManagementStudio -connectionString  $connectionString -script $sqlPath
}
