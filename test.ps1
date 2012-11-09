Import-Module `
    (join-path `
        -path ( ( [System.IO.FileInfo] ( $myinvocation.mycommand.path ) ).directory ) `
        -childPath 'ITG.Utils' `
    ) `
    -force `
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

<#
$test `
| ConvertFrom-Dictonary `
;
#>

@{
    'А'='A';
    'Б'='B';
    'В'='V';
    'Г'='G';
} `
| ConvertFrom-Dictonary `
| ? { 'А','Б' -contains $_.key } `
| ConvertTo-HashTable `
;