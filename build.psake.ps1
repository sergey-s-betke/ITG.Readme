$psake.use_exit_on_error = $true;

Properties {
	$CurrentDir = Resolve-Path . ;
	$ModuleName = Split-Path -Path '.' -Leaf -Resolve;
	$Invocation = Get-Variable MyInvocation -Scope 1 -ValueOnly;
}

Task default -depends Build;
Task Build -depends Test, BuildHelpSystem;
Task Release -depends Build;
Task BuildHelpSystem -depends BuildReadme, BuildModuleAboutFile, BuildUpdatableHelp;

Task Test {
<#
	CD "$baseDir"
	exec {."$baseDir\bin\Pester.bat"}
	CD $currentDir
#>
};

Task BuildReadme {
	Import-Module 'ITG.Readme';
	Import-Module $ModuleName -Force;
	Get-Module $ModuleName `
	| Set-Readme -Verbose `
	;
};

Task BuildModuleAboutFile {
	Import-Module 'ITG.Readme';
	Import-Module $ModuleName -Force;
	Get-Module $ModuleName `
	| Set-AboutModule -Verbose `
	;
};

Task BuildUpdatableHelp {
	Import-Module 'ITG.Readme';
	Import-Module $ModuleName -Force;
	Get-Module $ModuleName `
	| Set-HelpXML -PassThru -Cab -Verbose `
	| Set-HelpInfo -Verbose `
	;
};
