
SELECT * FROM dbo.AdlsSyncOffset 	WHERE TenantId = '##tenantId##' AND TypeName = '##typeName##'
SELECT * FROM dbo.AdlaTableInfo 	WHERE TenantId = '##tenantId##' AND TypeName = '##typeName##'
SELECT * FROM dbo.KpiJobsCheckpoint	WHERE TenantId = '##tenantId##' AND TypeName = '##typeName##'

-- _##tenantId##_##typeName##
if( '##typeName##' like '__system_%')
	SELECT '_'+'##tenantId##'+'_'+ ApiEntitySetName FROM dbo.TypeSerializationMetadata WHERE TenantId = '##tenantId##' AND TypeName = '##typeName##'
ELSE
	SELECT '_'+'##tenantId##'+'_'+ '##typeName##'
