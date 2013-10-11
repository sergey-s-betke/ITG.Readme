$ModuleName = Split-Path -Path '.' -Leaf -Resolve;

<#
Import-Module `
	-Name $ModuleName `
	-Function Expand-Definitions `
	-Force `
	-ErrorAction Stop `
;
#>

Describe 'TranslateRules' {

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

	It 'Expand-Definitions function must be avaliable for testing puprposes' {
		Test-PositiveAssertion( PesterExist 'Function:Expand-Definitions' );
	}

	It 'Use-TranslateRule run on $BasicTranslateRules without errors' {
		$BasicTranslateRules | Use-TranslateRule;
	}

	It 'hello, World test for Expand-Definitions' {
		'hello, World' | Expand-Definitions | Should Be 'hello, World';
	}

	It 'test about_* definitions: ''about_Aliases''' {
		'hello, about_Aliases World' | Expand-Definitions | Should Be 'hello, [about_Aliases][] World';
	}

	It 'test about_* definitions: change charcase for ''about_assignment_operators''' {
		'hello, about_assignment_operators' | Expand-Definitions | Should Be 'hello, [about_Assignment_Operators][]';
	}

	It 'test type definition: System.String' {
		'Return System.String type' | Expand-Definitions | Should Be 'Return [System.String][] type';
	}

	It 'test type definition: System.UnknownType' {
		'Return System.UnknownType type' | Expand-Definitions | Should Be 'Return System.UnknownType type';
	}

	It 'test definitions in code' {
		'`[System.String] $param`' | Expand-Definitions | Should Be '`[System.String] $param`';
		@"
	[System.String] `$param
"@ `
		| Expand-Definitions | Should Be @"
	[System.String] `$param
"@ `
		;
	}

}
