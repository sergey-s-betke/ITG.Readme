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
Get-Readme -Module ( Get-Module 'ITG.Readme' ) -OutDefaultFile;
Get-HelpXML -Module ( Get-Module 'ITG.Readme' ) -OutDefaultFile -Cab;
Set-HelpInfo -Module ( Get-Module 'ITG.Readme' );
