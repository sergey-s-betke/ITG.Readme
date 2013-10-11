$psake.use_exit_on_error = $true;

properties {
	$CurrentDir = Resolve-Path . ;
	$ModuleName = Split-Path -Path '.' -Leaf -Resolve;
	$Invocation = Get-Variable MyInvocation -Scope 1 -ValueOnly;
}

task default -depends Build;
task Build -depends Test, BuildHelpSystem;
task Release -depends Build;

task BuildHelpSystem -depends Test {
	Invoke-Psake '.\build.psake.HelpSystem.ps1';
}

task Test {
	Invoke-Psake '.\build.psake.Test.ps1';
};

task ? -description "Helper to display task info" {
	Write-Documentation;
}
