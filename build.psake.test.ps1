$psake.use_exit_on_error = $true;

task default -depends Test;

task Test {
	Import-Module `
		-Name Pester `
		-Force `
		-ErrorAction Stop `
	;

	Invoke-Pester;
};
