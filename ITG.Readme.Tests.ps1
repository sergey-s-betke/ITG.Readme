$ModuleName = Split-Path -Path '.' -Leaf -Resolve;
$ModuleDir = Resolve-Path -Path '.';

Describe 'Expand-Definitions' {

	Mock Export-ModuleMember;

	Setup -File "$ModuleName\$ModuleName.ps1" ( Get-Content "$ModuleDir\$ModuleName.psm1" | Out-String );
	Copy-Item `
		-Path "$ModuleDir" `
		-Destination 'TestDrive:' `
		-Recurse `
		-Force `
	;

	. "TestDrive:\$ModuleName\$ModuleName.ps1";

	It 'must be avaliable for testing puprposes' {
		'Function:Expand-Definitions' | Should Exist;
	}

	It 'Use-TranslateRule must run on $BasicTranslateRules without errors' {
		{ $BasicTranslateRules | Use-TranslateRule } | Should Not Throw;
	}

	It 'must return ''hello, World'' without changes' {
		'hello, World' | Expand-Definitions | Should Be 'hello, World';
	}

	Mock Add-EndReference;

	It 'must expand ''about_*'' definitions to markdown links ''[about_*][]''' {
		'hello, about_Aliases World' | Expand-Definitions | Should Be 'hello, [about_Aliases][] World';
		'hello, about_assignment_operators' | Expand-Definitions | Should Be 'hello, [about_Assignment_Operators][]';
		'hello, about_ActiveDirectory' | Expand-Definitions | Should Be 'hello, [about_ActiveDirectory][]';
		'hello, about_ActiveDirectory_Filter' | Expand-Definitions | Should Be 'hello, [about_ActiveDirectory_Filter][]';
		'hello, about_ActiveDirectory_Identity' | Expand-Definitions | Should Be 'hello, [about_ActiveDirectory_Identity][]';

		'hello, about_ActiveDirectory_ObjectModel' | Expand-Definitions | Should Be 'hello, [about_ActiveDirectory_ObjectModel][]';
		Assert-MockCalled Add-EndReference -Exactly 1 `
			-parameterFilter { $url -eq 'http://technet.microsoft.com/library/hh531528.aspx' } `
		;
	}

	It 'must expand system and PowerShell types' {
		'Return System.String type' | Expand-Definitions | Should Be 'Return [System.String][] type';
		'Return System.UnknownType type' | Expand-Definitions | Should Be 'Return System.UnknownType type';

		'Return Microsoft.ActiveDirectory.Management.ADSearchScope type' | Expand-Definitions | Should Be 'Return [Microsoft.ActiveDirectory.Management.ADSearchScope][] type';
		Assert-MockCalled Add-EndReference -Exactly 1 `
			-parameterFilter { $url -eq '<http://msdn.microsoft.com/ru-ru/library/microsoft.activedirectory.management.adsearchscope.aspx>' } `
		;
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

Describe 'Set-Readme' {

	Import-Module `
		-Name "$ModuleDir\$ModuleName.psd1" `
		-Force `
	;

	Copy-Item `
		-Path "$ModuleDir\Tests" `
		-Destination 'TestDrive:' `
		-Recurse `
		-Force `
	;

	It 'must be avaliable' {
		'Function:Set-Readme' | Should Exist;
		'Function:Get-Readme' | Should Exist;
	}

	It 'test module must be avaliable' {
		'TestDrive:\Tests\TestModule1\TestModule1.psd1' | Should Exist;
		'TestDrive:\Tests\TestModule1\TestModule1.psm1' | Should Exist;
		{
			Import-Module 'TestDrive:\Tests\TestModule1\TestModule1.psd1' -Force;
		} | Should Not Throw;
	}

	It 'must run for TestModule1 without errors' {
		{
			Get-Module 'TestModule1' `
			| Set-Readme `
			;
		} | Should Not Throw;
	}

	It 'readme.md for TestModule.md must exist' {
		'TestDrive:\Tests\TestModule1\readme.md' | Should Exist;
	}

	It 'must produce description for functions' {
		'TestDrive:\Tests\TestModule1\readme.md' | Should Contain '^#### Get-AboutTestFunction$';
	}

	It 'must not produce description for aliases' {
		'TestDrive:\Tests\TestModule1\readme.md' | Should Not Contain '^#### Get-AboutTest$';
	}

	It 'must generate alias section for functions' {
		'TestDrive:\Tests\TestModule1\readme.md' | Should Contain "\bGet-AboutTest\b";
	}

	It 'must generate readme.md as origin-readme.md' {
		Get-Content 'TestDrive:\Tests\TestModule1\readme.md' `
		| Out-String `
		| Should Be ( 
			Get-Content 'TestDrive:\Tests\TestModule1\origin-readme.md' `
			| Out-String `
		);
	}

	Remove-Module 'TestModule1' -Force;
}
