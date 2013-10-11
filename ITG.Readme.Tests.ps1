$ModuleName = Split-Path -Path '.' -Leaf -Resolve;

<#
Import-Module `
	-Name $ModuleName `
	-Function Expand-Definitions `
	-Force `
	-ErrorAction Stop `
;
#>

Describe 'Expand-Definitions' {

    Mock Export-ModuleMember;

	Setup -File "$ModuleName.ps1" ( Get-Content ".\$ModuleName.psm1" );

	. "TestDrive:$ModuleName.ps1";

	It 'must be avaliable for testing puprposes' {
		'Function:Expand-Definitions' | Should Exist;
	}

	It 'Use-TranslateRule must run on $BasicTranslateRules without errors' {
		{ $BasicTranslateRules | Use-TranslateRule } | Should Not Throw;
	}

	It 'must return ''hello, World'' without changes' {
		'hello, World' | Expand-Definitions | Should Be 'hello, World';
	}

	It 'must expand ''about_*'' definitions to markdown links ''[about_*][]''' {
		'hello, about_Aliases World' | Expand-Definitions | Should Be 'hello, [about_Aliases][] World';
		'hello, about_assignment_operators' | Expand-Definitions | Should Be 'hello, [about_Assignment_Operators][]';
	}

	It 'must expand system and PowerShell types' {
		'Return System.String type' | Expand-Definitions | Should Be 'Return [System.String][] type';
		'Return System.UnknownType type' | Expand-Definitions | Should Be 'Return System.UnknownType type';
	}

	It 'must not expand terms in code' {
		'`[System.String] $param`' | Expand-Definitions | Should Be '`[System.String] $param`';
		@"
	[System.String] `$param
"@ `
		| Expand-Definitions | Should Be @"
	[System.String] `$param
"@ `
		;
	}

	It 'must expand PowerShell cmdlets names to links' {
		'Use Get-Command for this purpose' | Expand-Definitions | Should Be 'Use [Get-Command][] for this purpose';
	}

}
