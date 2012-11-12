function ConvertFrom-Dictionary {
	<#
		.Synopsis
			Конвертация таблицы транслитерации и любых других словарей в массив объектов
			с целью дальнейшей сериализации.
		.Example
			@{'А'='A'; 'Б'='B'; 'В'='V'} | ConvertFrom-Dictionary;
	#>
	
	
	param (
		# Исходный словарь для конвейеризации
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject
	)

	process {
		$InputObject.GetEnumerator();
	}
}

New-Alias -Name Get-Pair -Value ConvertFrom-Dictionary;

function Set-ObjectProperty {
	<#
		.Synopsis
			Добавление либо изменение свойств объекта, поступающего по контейнеру
		.Example
			@{'А'='A'; 'Б'='B'; 'В'='V'} | Set-ObjectProperty -key zz -value 3 -PassThru
			Добавляем в hashtable (можно и PSObject) свойство zz со значением 3.
		.Example
			Set-ObjectProperty -InputObject $test -key prop -value 'val' -PassThru;
	#>
	[CmdletBinding(
	)]
	param (
		# Ключ key для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=0
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Key
	,
		# Значение Value для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=1
		)]
		$Value
	,
		# Исходный словарь, в который будут добавлены сопоставления.
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
		)]
		[ValidateNotNull()]
		$InputObject
	,
		[switch]
		$PassThru
	)

	process {
		$InputObject.$Key = $Value;
		if ( $PassThru ) { return $InputObject;	};
	}
}

function ConvertTo-ObjectProperty {
	<#
		.Synopsis
			Преобразование однотипных объектов со свойствами key и value в единый объект,
			свойства которого определены поданными на конвейер парами.
		.Example
			@{'А'='A'; 'Б'='B'} | ConvertFrom-Dictionary | ? { 'А' -contains $_.key } | ConvertTo-ObjectProperty -PassThru;
		.Example
			@{'А'='A'; 'Б'='B'} | ConvertFrom-Dictionary | ConvertTo-ObjectProperty -InputObject (@{a=2;zzzzz=3}) -PassThru;
	#>
	[CmdletBinding(
		DefaultParameterSetName="NewObject"
	)]
	param (
		# Ключ key для hashtable.
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Key
	,
		# Значение Value для hashtable.
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		$Value
	,
		# Тип словаря, будет использован при создании нового словаря.
		[Parameter(
			Mandatory=$false
			, ParameterSetName="NewObject"
		)]
		[Type]
		$TypeName = [PSObject]
	,
		# Исходный словарь, в который будут добавлены сопоставления.
		[Parameter(
			Mandatory=$false
			, ValueFromPipeline=$true
			, ParameterSetName="ExistingObject"
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject
	,
		[switch]
		$PassThru
	)

	begin {
		switch ( $PSCmdlet.ParameterSetName ) {
			'NewObject' { $res = ( New-Object -TypeName $TypeName ); }
			'ExistingObject' { $res = $InputObject; }
		};
	}
	process {
		if (
			( $res -is [System.Collections.IDictionary] ) `
			-or ( Get-Member -InputObject $res -MemberType Properties -Name $Key )
		) {
			$res.$Key = $Value;
		} else {
			Add-Member -InputObject $res -MemberType NoteProperty -Name $Key -Value $Value;
		};
	}
	end {
		if ( $PassThru ) { return $res; };
	}
}

New-Alias -Name ConvertTo-PSObject -Value ConvertTo-ObjectProperty;
New-Alias -Name Add-Pair -Value ConvertTo-ObjectProperty;

function Get-ModuleReadme {
	<#
		.Synopsis
			Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
			Файл предназначен, в частности, для размещения в репозиториях github.
		.Notes
			To-Do:
			- автоматический поиск и генерацию ссылок по переданному словарю
			- подробное описание функций после краткого обзора
			- генерация ссылок по наименованиям других функций модуля, и других модулей, если таковые указаны
			- автоматическое выделение url и формирование синтаксиса ссылки в разделах Link
		.Link
			[MarkDown (md) Syntax](http://daringfireball.net/projects/markdown/syntax)
		.Link
			[about_comment_based_help](http://technet.microsoft.com/ru-ru/library/dd819489.aspx)
		.Link
			[Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-ModuleReadme | Out-File -Path 'readme.md' -Encoding 'UTF8' -Width 1024;
			Генерация readme.md файла для модуля `ITG.Yandex.DnsServer` 
			в текущем каталоге.
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-ModuleReadme -OutDefaultFile;
			Генерация readme.md файла для модуля `ITG.Yandex.DnsServer` 
			в каталоге модуля.
	#>
	
	[CmdletBinding(
	)]

	param (
		# Описатель модуля
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
		)]
		[ValidateNotNullOrEmpty()]
		[PSModuleInfo]
		$Module
,
		[switch]
		$OutDefaultFile
	)

	process {
		$ReadMeContent = & {
		$Funcs = `
		Get-Command `
			-Module $Module `
			-CommandType Function, Filter `
		| % {
			$_ `
			| Add-Member -PassThru -Name Verb -MemberType NoteProperty -Value ( ( $_.Name -split '-')[0] ) `
			| Add-Member -PassThru -Name Noun -MemberType NoteProperty -Value ( ( $_.Name -split '-' )[1] ) `
		} `
		| Sort-Object Noun, Verb `
		| % {
			Add-Member `
				-InputObject $_ `
				-Name Syntax `
				-MemberType NoteProperty `
				-Value (
					( (
						Get-Command `
							-Name $_.Name `
							-Module $Module `
							-Syntax `
					) -split "(?m)$" ) `
					| ? { -not ( [string]::IsNullOrWhiteSpace( $_ ) ) } `
				) `
				-PassThru `
			| Add-Member `
				-Name Help `
				-MemberType NoteProperty `
				-Value ( $_ | Get-Help -Full ) `
				-PassThru `
			| Add-Member `
				-InputObject $_ `
				-Name Syntax2 `
				-MemberType NoteProperty `
				-Value (
					$_.Help.Syntax.SyntaxItem `
					| % {
						$_.Name,
						( 
							$_.Parameter `
							| % {
								"-$($_.Name)"
							}
						) `
						-join ' '
					}
<#
Синтаксис можно полностью построить и самостоятельно:
$s1=(Get-Help convertto-ObjectProperty -Full).syntax.syntaxitem[0]
$s1.Name
$s1.parameter[0]

-Key <String>
    Ключ key для hashtable.
    
    Требуется?                    true
    Позиция?                    named
    Значение по умолчанию                
    Принимать входные данные конвейера?true (ByPropertyName)
    Принимать подстановочные знаки?
PS C:\Users\Sergey.S.Betke\Documents> $p1 =$s1.parameter[0]
PS C:\Users\Sergey.S.Betke\Documents> $p1 | gm
   TypeName: MamlCommandHelpInfo#parameter
Name           MemberType   Definition                                                                                 
----           ----------   ----------                                                                                 
Equals         Method       bool Equals(System.Object obj)                                                             
GetHashCode    Method       int GetHashCode()                                                                          
GetType        Method       type GetType()                                                                             
ToString       Method       string ToString()                                                                          
description    NoteProperty System.Management.Automation.PSObject[] description=System.Management.Automation.PSObject[]
name           NoteProperty System.String name=Key                                                                     
parameterValue NoteProperty System.String parameterValue=String                                                        
pipelineInput  NoteProperty System.String pipelineInput=true (ByPropertyName)                                          
position       NoteProperty System.String position=named                                                               
required       NoteProperty System.String required=true                                                                
#>
				) `
				-PassThru `
		} `
		;
@"
$($Module.Name)
$($Module.Name -replace '.','=')

$($Module.Description)

Версия модуля: **$( $Module.Version.ToString() )**
"@
		$Funcs `
		| Group-Object Noun `
		| % -Begin {
@"

Функции модуля
--------------
"@
		} `
		-Process {
@"
			
### $($_.Name)
"@
			$_.Group `
			| % {
@"
			
#### $($_.Name)

$( $_.Help.Synopsis )
"@
				$_.Syntax `
				| % {
@"
	
	$_
"@
				};
			};
		};

		$Funcs `
		| % -Begin {
@"

Подробное описание функций модуля
---------------------------------
"@
		} `
		-Process {
@"
			
#### $($_.Name)

$( & {
	if ( $_.Help.Description ) {
		$_.Help.Description;
	} else {
		$_.Help.Synopsis;
	}
} )

##### Синтаксис
"@
			$_.Syntax `
			| % {
@"
	
	$_
"@
			};

			if ( ( @( $_.Help.examples) ).count ) {
				$_.Help.Examples.example `
				| % -Begin {
					$ExNum=0;
@"

##### Примеры использования	
"@
				} `
				-Process {
					++$ExNum;
					$Comment = (
						( 
							$_.remarks `
							| % { $_.Text } 
						) -join ' ' 
					).Trim( ' ', (("`t").Normalize()) );
					if ( $Comment ) {
@"

$ExNum. $Comment
"@
					} else {
@"

$ExNum. Пример $ExNum.
"@
					};
@"

		$($_.code)
"@
				};
			};

			$links = `
				$_.Help.relatedLinks.navigationLink `
				| ? { $_.LinkText } `
			;
			if ( $links ) {
				$links `
				| % -Begin {
@"

##### Связанные ссылки

"@
				} `
				-Process {
@"
- $($_.LinkText)
"@
				};
			};
		};
		};
		if ( $OutDefaultFile ) {
			$ReadMeContent `
			| Out-File `
				-FilePath ( Join-Path `
					-Path ( Split-Path -Path ( $Module.Path ) -Parent ) `
					-ChildPath 'readme.md' `
				) `
				-Force `
				-Encoding 'UTF8' `
				-Width 1024 `
			;
		} else {
			return $ReadMeContent;
		};
	}
}

Export-ModuleMember `
	-Alias `
		Get-Pair `
		, Add-Pair `
		, ConvertTo-Dictionary `
		, ConvertTo-PSObject `
	-Function `
		ConvertFrom-Dictionary `
		, Set-ObjectProperty `
		, ConvertTo-ObjectProperty `
		, Get-ModuleReadme `
;