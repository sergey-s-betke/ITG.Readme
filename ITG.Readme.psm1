[System.Text.RegularExpressions.Regex]$reDomain = `
	"(?<domain>(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+(?:aero|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-zA-Z]{2}))";
[System.Text.RegularExpressions.Regex]$rePort = `
	"(?:[:](?<port>\d+))";
[System.Text.RegularExpressions.Regex]$reSocket = `
	"(?<socket>${reDomain}${rePort}?)";
[System.Text.RegularExpressions.Regex]$reSchema = `
	"(?<schema>http|https|ftp)";
[System.Text.RegularExpressions.Regex]$reURLToken = `
	"(?:(?:%[0-9a-fA-F]{2})|[a-zA-Z0-9`-`.]|&[a-z]+;)";
[System.Text.RegularExpressions.Regex]$reURLPathEl = `
	"${reURLToken}+";
[System.Text.RegularExpressions.Regex]$reURLPath = `
	"(?<path>${reURLPathEl}(?:/${reURLPathEl})*)";
[System.Text.RegularExpressions.Regex]$reURLParam = `
	"(?<paramName>${reURLToken}+)=(?<paramValue>${reURLToken}+)";
[System.Text.RegularExpressions.Regex]$reURLParams = `
	"(?:(?:[?])(?<params>${reURLParam}(?:&${reURLParam})*))";
[System.Text.RegularExpressions.Regex]$reURLAnchor = `
	"(?:(?:#)(?<anchor>${reURLToken}+))";
[System.Text.RegularExpressions.Regex]$reURL = `
	"(?<url>${reSchema}://${reDomain}${rePort}?(?:/${reURLPath}?${reURLParams}?${reURLAnchor}?)?)";
[System.Text.RegularExpressions.Regex]$reURLShortHTTP = `
	"(?<url>(?<domain>(?:www)`.${reDomain})${rePort}?(?:/${reURLPath}?${reURLParams}?${reURLAnchor}?)?)";
[System.Text.RegularExpressions.Regex]$reURLShortFTP = `
	"(?<url>(?<domain>(?:ftp)`.${reDomain})${rePort}?(?:/${reURLPath}?${reURLParams}?${reURLAnchor}?)?)";

$BasicTranslateRules = `
	  @{ template=[System.Text.RegularExpressions.Regex]"[ `t]*`r?`n"; expression="`r`n" } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<=(`r?`n){2})(`r?`n)*"; expression='' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortHTTP}"; expression='<http://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortFTP}"; expression='<ftp://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURL}"; expression='<$0>' } `
;
$LinkTranslateRules = `
	  @{ template=[System.Text.RegularExpressions.Regex]"[ `t]*`n"; expression="`r`n" } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortHTTP}"; expression='<http://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortFTP}"; expression='<ftp://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"^${reURL}\s+(?<description>.*)"; expression='[${description}](${url})' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURL}"; expression='<$0>' } `
;

Function ExpandDefinitions {
	<#
		.Synopsis
			Данная функция выделяет определения из подготовленного readme и оформляет их в соответствии со 
			словарём.
	#>
	
	param (
		# трансформируемый текст readme
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
		)]
		[String]
		$InputObject
	,
		[Parameter(
			Mandatory=$true
		)]
		[Array]
		$TranslateRules
	)

	process {
		foreach( $Rule in $TranslateRules ) {
			$InputObject = $InputObject -replace $Rule.Template, $Rule.Expression;
		};
		return $InputObject;
	}
}

Function Get-Readme {
	<#
		.Synopsis
			Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям. 
			Файл предназначен, в частности, для размещения в репозиториях github.
		.Functionality
			Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям. 
			Файл предназначен, в частности, для размещения в репозиториях github. 
			
			Описание может быть сгенерировано для модуля, функции, внешего сценария.
		.Role
			Everyone
		.Notes
			To-Do:
			- автоматический поиск и генерацию ссылок по переданному словарю
			- генерация ссылок по наименованиям других функций модуля, и других модулей, если таковые указаны
			- автоматическое выделение url и формирование синтаксиса ссылки в разделах Link
			- ввести поддержку генерации файла для внешних скриптов (именно - с генерацией файла)
			- а также для прочих членов модуля
			- about_commonparameters и другие аналогичные так же в ссылки преобразовывать
		.Inputs
			System.Management.Automation.PSModuleInfo - 
			Описатели модулей. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Module.
		.Inputs
			System.Management.Automation.CmdletInfo - 
			Через конвейер функция принимает описатели командлет. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Inputs
			System.Management.Automation.FunctionInfo - 
			Через конвейер функция принимает описатели функций. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Inputs
			System.Management.Automation.ExternalScriptInfo - 
			Через конвейер функция принимает описатели внешних сценариев. Именно для них и будет сгенерирован readme.md. 
		.Outputs
			String. Содержимое readme.md.
		.Link
			http://daringfireball.net/projects/markdown/syntax
			MarkDown (md) Syntax
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
				$ReadMeContent = & { `
@"
$($ModuleInfo.Name)
$($ModuleInfo.Name -replace '.','=')

$($ModuleInfo.Description)

Версия модуля: **$( $ModuleInfo.Version.ToString() )**
"@
					if ( $ModuleInfo.ExportedFunctions ) {
						$ModuleInfo.ExportedFunctions.Values `
						| Sort-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
							, @{ Expression={ ( $_.Name -split '-' )[0] } } `
						| Group-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
						| % -Begin {
@"

Функции модуля
--------------
"@
						} `
						-Process {
							if ( $_.Name ) {
@"
			
### $($_.Name)
"@
							};
							$_.Group `
							| Get-Readme -ShortDescription `
							;
						};

						if ( -not $ShortDescription ) {
@"

Подробное описание функций модуля
---------------------------------
"@
							$ModuleInfo.ExportedFunctions.Values `
							| Sort-Object -Property `
								@{ Expression={ ( $_.Name -split '-' )[1] } } `
								, @{ Expression={ ( $_.Name -split '-' )[0] } } `
							| Get-Readme `
							;
						};
					};
				};
				$ReadMeContent = `
					$ReadMeContent `
					| Out-String `
					| ExpandDefinitions -TranslateRules $BasicTranslateRules `
				;
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
				$ReadMeContent = & { `
					$Help = ( $FunctionInfo | Get-Help -Full );
					if ( $Help.Syntax ) {
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
					} else {
						$Syntax = $Help.Synopsis;
					};
@"
			
#### $($FunctionInfo.Name)

"@
					if ( $ShortDescription ) {
						$Help.Synopsis;
						if ( $Help.Syntax ) {
							$Syntax `
							| % {
@"
	
	$_
"@
							};
						};
					} else {
						if ( $Help.Description ) {
							$Help.Description `
							| Select-Object -ExpandProperty Text `
							;
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

$($Help.Functionality)
"@
						};
						if ( $Help.Role ) {
@"

##### Требуемая роль пользователя

Для выполнения функции $($FunctionInfo.Name) требуется роль $($Help.Role) для учётной записи,
от имени которой будет выполнена описываемая функция.
"@
						};
						if ( $Help.inputTypes ) {
@"

##### Принимаемые данные по конвейеру
"@
							$Help.inputTypes.inputType `
							| % {
@"

$($_.type.name)
"@
							};
						};
						if ( $Help.returnValues ) {
@"

##### Передаваемые по конвейеру данные
"@
							$Help.returnValues.returnValue `
							| % {
@"

$($_.type.name)
"@
							};
						};
						if ( $Help.Parameters ) {
							$ParamsDescription = `
								( $Help.Parameters | Out-String ) `
								-replace '<CommonParameters>', '-<CommonParameters>' `
								-replace '(?m)^\p{Z}{4}-(.+)?\s*?$', '- `$1`' `
							;
@"

##### Параметры	
$ParamsDescription
"@
						};
						if ( $Help.Examples ) {
							$Help.Examples.Example `
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
										| Select-Object -ExpandProperty Text `
										| ? { $_ } `
									) -join ' ' `
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
						if ( $Help.relatedLinks ) {
@"

##### Связанные ссылки

"@
							$Help.relatedLinks.navigationLink `
							| % {
								$Link = `
									$_.LinkText + $_.uri `
									| ExpandDefinitions -TranslateRules $LinkTranslateRules `
								;
@"
- $Link
"@
							};
						};
					};
				};
				return $ReadMeContent;
			};
		};
	}
}

Export-ModuleMember `
	Get-Readme `
;