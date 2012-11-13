[CmdletBinding()]
param()

$Module = Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Readme' `
	) `
	-Force `
	-Verbose `
	-PassThru `
;
Get-Readme -Module $Module -OutDefaultFile;