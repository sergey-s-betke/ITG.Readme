[CmdletBinding()]
param()

$Module = Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Utils' `
	) `
	-Force `
	-Verbose `
	-PassThru `
;
Get-ModuleReadme -Module $Module -OutDefaultFile;

set-variable `
	-name test `
	-value `
	@{
		'А'='A';
		'Б'='B';
		'В'='V';
		'Г'='G';
		'Д'='D';
		'Е'='E';
		'Ё'='E';
		'Ж'='ZH';
		'З'='Z';
		'И'='I';
		'Й'='I';
		'К'='K';
		'Л'='L';
		'М'='M';
		'Н'='N';
		'О'='O';
		'П'='P';
		'Р'='R';
		'С'='S';
		'Т'='T';
		'У'='U';
		'Ф'='F';
		'Х'='KH';
		'Ц'='TC';
		'Ч'='CH';
		'Ш'='SH';
		'Щ'='SHCH';
		'Ь'='';
		'Ы'='Y';
		'Ъ'='';
		'Э'='E';
		'Ю'='IU';
		'Я'='IA';
	} `
;

#$test `
#| ConvertFrom-Dictionary `
#| Add-Pair -PassThru `

#$test `
#| ConvertFrom-Dictionary `
#| Add-Pair -InputObject (@{a=2;zzzzzzzzzzzz=3}) -PassThru

#$test `
#| Add-Pair -key zzzzzzzzzzzz -value 3 -PassThru

#$test `
#| Add-Pair -key zzzzzzzzzzzz -value 3;
#$test;

#Add-Pair -InputObject $test -key prop -value 'val' -PassThru;

#$test `
#| ConvertFrom-Dictionary `
#| ConvertTo-PSObject -PassThru `
#

#Get-Module 'ITG.Yandex.DnsServer' `
#| Tee-Object -Variable Module `
#| Get-ModuleReadme `
#| Out-File `
#	-FilePath ( Join-Path `
#   	 -Path ( Split-Path -Path ( $Module.Path ) -Parent ) `
#   	 -ChildPath 'readme.md' `
#    ) `
#	-Force `
#	-Encoding 'UTF8' `
#	-Width 1024 `
#;

#Get-Module 'ITG.Yandex.DnsServer' `
#| Tee-Object -Variable Module `
#| Get-ModuleReadme -OutDefaultFile `
#;
