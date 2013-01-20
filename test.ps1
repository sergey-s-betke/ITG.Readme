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
Set-Readme -Module ( Get-Module 'ITG.Readme' );
Set-HelpXML -Module ( Get-Module 'ITG.Readme' ) -Cab; # -UpdateModule;
Set-HelpInfo -Module ( Get-Module 'ITG.Readme' ); # -UpdateManifest;
