# SsmsOpener

PowerShell library for opening MS SQL Server Management Studio for a specific connection string and sql script template.  
[Video](https://microsoft-my.sharepoint.com/:v:/p/v-alfara/EQmaVCUT9XdEiEzpAsDaO8oBnOTbaZE5h2ek6WQSLGyrTA?e=rb8jZ0)

 
## Usage
**Without template**
```
PS> OpenMicrosoftSQLServerManagementStudio `
		-connectionString "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****" `
		-script .\my.sql
```
**With template**
```
PS> CreateSqlAndOpenSsms  `
		-connectionString "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****" `
		-sqlTemplateName 'kpi_incident' `
		-templateVariables @{'tenantId' = $tenantId; 'typeName' = $typeName}
```
---
or you can define your own function for process input parameters and create `templateVariables` 
```
PS> OpenSsmsForKPIIncident 
	-incidentString aadci2c80eef4a8804ba08a_LeadScoringModel 
	-connectionString "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****"
```
or short variant with function alias name and without parameter names 
```
PS> ssms-kpi aadci2c80eef4a8804ba08a_LeadScoringModel "Data Source=XXX;Initial Catalog=YYY;User ID=userName;Password=*****"	
```

## How to add your own template and function
1. Add template fail into `\templates` folder with extension `.tmpl.sql` (ex: `\templates\kpi_incident.tmpl.sql`)
2. Create function and alias, if you you need. As example you can use `KPI-Helper.ps1` script. 
3. Add your variables, functions, alias into exported module members.( see `SsmsOpener.psm1`) 

## How to import module

There is few options: 

1. Add module folder into `$ENV:PSModulePath`   
2. Import module from code manually   
```PS> Import-Module <full path to module folder>\SsmsOpener```  
3. Place module in folder from `$ENV:PSModulePath`  

Convenient way add module into your environment is modify your `$PROFILE`  
* `PS> notepad $PROFILE`
* addend in file `$ENV:PSModulePath = $ENV:PSModulePath + ';<full path to module folder>'` 
* save file
* restart PowerShell

## Templates
Template file must has name `<tempalteName>.tmpl.sql` and be placed in folder `<moduleFolder>\templates\`. Folder can be overridden: `$SsmsOpenerTemplateFolder`.   
_template content_
```

SELECT * FROM dbo.AdlaTableInfo WHERE TenantId = '##tenantId##' AND TypeName = '##typeName##'
```
Generated sql file will placed in folder `<moduleFolder>\generated\`. Folder can be overridden: `$SsmsOpenerGeneratedFolder`.  
