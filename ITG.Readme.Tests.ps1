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

	Get-Content `
		-Path ".\$ModuleName.psm1" `
		-ErrorAction Stop `
	| Set-Content `
		-Path ".\$ModuleName.ps1" `
		-ErrorAction Stop `
	;
	. ".\$ModuleName.ps1";
	Remove-Item `
		-Path  ".\$ModuleName.ps1" `
		-Force `
	;

	It 'must be avaliable for testing puprposes' {
		Test-PositiveAssertion( PesterExist 'Function:Expand-Definitions' );
	}

	It 'Use-TranslateRule must run on $BasicTranslateRules without errors' {
		$BasicTranslateRules | Use-TranslateRule;
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
