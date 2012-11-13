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

function Get-Readme {
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
			- ввести поддержку генерации файла для внешних скриптов (именно - с генерацией файла)
			- а также для прочих членов модуля
			- about_commonparameters и другие аналогичные так же в ссылки преобразовывать
		.Inputs
			Через конвейер функция принимает описатели модулей, функций, скриптов. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Module, Get-Command и так далее.
		.Outputs
			String. Содержимое readme.md.
		.Link
			[MarkDown (md) Syntax](http://daringfireball.net/projects/markdown/syntax)
		.Link
			[about_comment_based_help](http://technet.microsoft.com/ru-ru/library/dd819489.aspx)
		.Link
			[Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-Readme | Out-File -Path 'readme.md' -Encoding 'UTF8' -Width 1024;
			Генерация readme.md файла для модуля `ITG.Yandex.DnsServer` 
			в текущем каталоге.
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -OutDefaultFile;
			Генерация readme.md файла для модуля `ITG.Yandex.DnsServer` 
			в каталоге модуля.
	#>
	
	[CmdletBinding(
		DefaultParametersetName='ModuleInfo'
	)]

	param (
		# Описатель модуля
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
			, ParameterSetName='ModuleInfo'
		)]
		[PSModuleInfo]
		[Alias('Module')]
		$ModuleInfo
,
		[Parameter(
			ParameterSetName='ModuleInfo'
		)]
		[switch]
		$OutDefaultFile
,
		# Описатель внешнего сценария
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
			, ParameterSetName='ExternalScriptInfo'
		)]
		[System.Management.Automation.ExternalScriptInfo]
		$ExternalScriptInfo
,
		# Описатель внешнего сценария
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
			, ParameterSetName='FunctionInfo'
		)]
		[System.Management.Automation.FunctionInfo]
		$FunctionInfo
,
		[switch]
		[Alias('Short')]
		$ShortDescription
)

	process {
		switch ( $PsCmdlet.ParameterSetName ) {
			'ModuleInfo' {
				$Funcs = @( `
					$ModuleInfo.ExportedFunctions.Values `
					| Sort-Object -Property `
						@{ Expression={ ( $_.Name -split '-' )[1] } } `
						, @{ Expression={ ( $_.Name -split '-' )[0] } } `
				);
				$ReadMeContent = & { `
@"
$($ModuleInfo.Name)
$($ModuleInfo.Name -replace '.','=')

$($ModuleInfo.Description)

Версия модуля: **$( $ModuleInfo.Version.ToString() )**
"@
					$Funcs `
					| Group-Object -Property `
						@{ Expression={ ( $_.Name -split '-' )[1] } } `
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
						| Get-Readme -ShortDescription `
						;
					};

					if ( -not $ShortDescription ) {
@"

Подробное описание функций модуля
---------------------------------
"@
						$Funcs `
						| Get-Readme `
						;
					};
				};
				if ( $OutDefaultFile ) {
					$ReadMeContent `
					| Out-File `
						-FilePath ( Join-Path `
							-Path ( Split-Path -Path ( $ModuleInfo.Path ) -Parent ) `
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
			'ExternalScriptInfo' {
			}
			'FunctionInfo' {
				$Help = ( $FunctionInfo | Get-Help -Full );
				$Syntax = (
					$Help.Syntax.SyntaxItem `
					| % {
						,$_.Name `
						+ ( 
							$_.Parameter `
							| % {
								#MamlCommandHelpInfo#parameter
								$name="-$($_.Name)";
								if ( $_.position -ne 'named' ) {
									$name="[$name]";
								};
								if ( $_.parameterValue ) {
									$param = "$name <$($_.parameterValue)>";
								} else {
									$param = "$name";
								};
								if ( $_.required -ne 'true' ) {
									$param = "[$param]";
								};
								$param;
							}
						) `
						+ ( & {
							if ( $FunctionInfo.CmdletBinding ) { '<CommonParameters>' }
						} ) `
						-join ' '
					}
				);
@"
			
#### $($FunctionInfo.Name)

"@
				if ( $ShortDescription ) {
					$Help.Synopsis;
					$Syntax `
					| % {
@"
	
	$_
"@
					};
				} else {
					if ( $Help.Description ) {
						$Help.Description;
					} else {
						$Help.Synopsis;
					};
@"

##### Синтаксис
"@
					$Syntax `
					| % {
@"
	
	$_
"@
					};
					if ( $Help.Component ) {
@"

##### Компонент

$($Help.Component)
"@
					};
					if ( $Help.Functionality ) {
@"

##### Функциональность

Описываемая функция предоставляет следующую функциональность: $($Help.Functionality).
"@
					};
					if ( $Help.Role ) {
@"

##### Требуемая роль пользователя

Для выполнения функции $($FunctionInfo.Name) требуется роль $($Help.Component) для учётной записи,
от имени которой будет выполнена описываемая функция.
"@
					};

					if ( $Help.Inputs ) {
@"

##### Принимаемые данные по конвейеру

$($Help.Inputs)
"@
					};
					if ( $Help.Outputs ) {
@"

##### Передаваемые по конвейеру данные

$($Help.Outputs)
"@
					};
					
					if ( $Help.Parameters.parameter.Count ) {
@"

##### Параметры	
$( $Help.Parameters | Out-String )
"@
					};
					
					if ( ( @( $Help.examples ) ).count ) {
						$Help.Examples.example `
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
						$Help.relatedLinks.navigationLink `
						| ? { $_.LinkText } `
					;
					if ( $links ) {
@"

##### Связанные ссылки

"@
						$links `
						| % {
@"
- $($_.LinkText)
"@
						};
					};
				};
			};
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
		, Get-Readme `
;