<#
.SYNOPSIS
Create sql script for kpi icm incident and opens the script into Microsoft SQL Server Management Studio
.PARAMETER incidentString
tenantId and typeName string separated by `_`
.PARAMETER connectionString
ms sql connection string 
.EXAMPLE
OpenSsmsForKPIIncident aadci2c80eef4a8804ba08a_LeadScoringModel "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****"
.EXAMPLE
ssms-kpi aadci2c80eef4a8804ba08a_LeadScoringModel "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****"
#>
function OpenSsmsForKPIIncident {
    param(
        [Parameter(Mandatory = $true)]    
        [string] $incidentString,

        [Parameter(Mandatory = $true)]    
        [string] $connectionString
    )

    $splitPosition = $incidentString.IndexOf('_');
    $tenantId = $incidentString.Substring(0, $splitPosition);
    $typeName = $incidentString.Substring($splitPosition + 1);

    CreateSqlAndOpenSsms  `
		-connectionString $connectionString `
        -sqlTemplateName 'kpi_incident' `
        -templateVariables @{'tenantId' = $tenantId; 'typeName' = $typeName}
}

Set-Alias ssms-kpi OpenSsmsForKPIIncident