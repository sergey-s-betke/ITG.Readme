$psake.use_exit_on_error = $true;

properties {
	$CurrentDir = Resolve-Path . ;
	$ModuleName = Split-Path -Path '.' -Leaf -Resolve;
	$Invocation = Get-Variable MyInvocation -Scope 1 -ValueOnly;
}

task default -depends Test;

task Test {
<#
	$here = (Split-Path -parent $MyInvocation.MyCommand.Definition);

	Import-Module ($here + "\PsGet\PsGet.psm1") -Force;

	try {
    	Import-Module Pester -Force
	} catch {
    	Write-Warning "Unable to import module 'Pester' required for testing, attempting to install Pester via PsGet module ... "
    	Install-Module pester
	};

	Invoke-Pester -relative_path $here -EnableExit:$EnableExit
#>
};
