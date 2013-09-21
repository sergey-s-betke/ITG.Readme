[CmdletBinding()]
param()

Import-Module `
    -Name 'ITG.Readme' `
	-Force `
;

<#

Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Readme.psd1' `
	) `
	-Force `
	-Verbose `
;

#>

<#
$m = Get-Module -Name 'ITG.Readme';
$m | Set-Readme `
    -Path ( `
	    $m.ModuleBase `
	    | Join-Path -ChildPath 'readme.md' `
    ) `
;
#>

Set-Readme -Module ( Get-Module 'ITG.Readme' );
Set-AboutModule -Module ( Get-Module 'ITG.Readme' );
Set-HelpXML -Module ( Get-Module 'ITG.Readme' ); # -Cab; # -UpdateModule;
Set-HelpInfo -Module ( Get-Module 'ITG.Readme' ); # -UpdateManifest;
# ( Get-HelpXML -Module ( Get-Module 'ITG.Readme' ) ).OuterXml;
