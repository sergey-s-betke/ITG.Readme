[CmdletBinding()]
param()

Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Readme.psd1' `
	) `
	-Force `
	-Verbose `
;
# Get-Readme -Module ( Get-Module 'ITG.Readme' ) -OutDefaultFile;
( Get-Module 'ITG.Readme' ) | Get-HelpXML -OutDefaultFile;
# (Get-Help Get-HelpXML -Full).functionality