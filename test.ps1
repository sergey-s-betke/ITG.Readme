Import-Module `
    (join-path `
        -path ( ( [System.IO.FileInfo] ( $myinvocation.mycommand.path ) ).directory ) `
        -childPath 'ITG.Utils' `
    ) `
    -Force `
	-Verbose `
;

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
#| Get-Pair `
#| Add-Pair -PassThru `
#;

#$test `
#| get-pair `
#| Add-Pair -InputObject (@{a=2;zzzzzzzzzzzz=3}) -PassThru

#$test `
#| Add-Pair -key zzzzzzzzzzzz -value 3 -PassThru
#;

#$test `
#| Add-Pair -key zzzzzzzzzzzz -value 3;
#$test;

#$test `
#| get-pair `
#| Add-CustomMember

Get-Module 'ITG.Yandex.DnsServer' `
| Tee-Object -Variable Module `
| Get-ModuleReadme `
| Out-File `
	-FilePath ( Join-Path `
        -Path ( Split-Path -Path ( $Module.Path ) -Parent ) `
        -ChildPath 'readme.md' `
    ) `
	-Force `
	-Encoding 'UTF8' `
	-Width 1024 `
;