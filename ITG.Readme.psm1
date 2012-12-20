'ITG.RegExps' `
| Import-Module `
;

$PowerShellBaseHelpUrl = 'http://go.microsoft.com/fwlink/?LinkID=';
$PowerShellAboutTopics = @{
	'about_Aliases' = 113207
	'about_Arithmetic_Operators' = 113208
	'about_Arrays' = 113209
	'about_Assignment_Operators' = 113210
	'about_Automatic_Variables' = 113212
	'about_Break' = 113213
	'about_Command_Precedence' = 113214
	'about_Command_Syntax' = 113215
	'about_Comment_Based_Help' = 144309
	'about_CommonParameters' = 113216
	'about_Comparison_Operators' = 113217
	'about_Continue' = 113218
	'about_Core_Commands' = 113219
	'about_Data_Sections' = 113220
	'about_Debuggers' = 113221
	'about_Do' = 135169
	'about_Environment_Variables' = 113222
	'about_Escape_Characters' = 113223
	'about_EventLogs' = 113224
	'about_Execution_Policies' = 135170
	'about_For' = 113228
	'about_Foreach' = 113229
	'about_Format.ps1xml' = 113230
	'about_Functions' = 113231
	'about_Functions_Advanced' = 144511
	'about_Functions_Advanced_Methods' = 135172
	'about_Functions_Advanced_Parameters' = 135173
	'about_Functions_CmdletBindingAttribute' = 135174
	'about_Hash_Tables' = 135175
	'about_History' = 113233
	'about_If' = 113234
	'about_Job_Details' = 135176
	'about_jobs' = 113251
	'about_Join' = 113235
	'about_Language_Keywords' = 136588
	'about_Line_Editing' = 113236
	'about_Locations' = 113237
	'about_Logical_Operators' = 113238
	'about_Methods' = 113239
	'about_Modules' = 144311
	'about_Objects' = 113241
	'about_Operators' = 113242
	'about_Parameters' = 113243
	'about_Parsing' = 113244
	'about_Path_Syntax' = 113245
	'about_Pipelines' = 113246
	'about_Preference_Variables' = 113248
	'about_Profiles' = 113729
	'about_Prompts' = 135179
	'about_Properties' = 113249
	'about_Providers' = 113250
	'about_PSSession_Details' = 135180
	'about_PSSessions' = 135181
	'about_PSsnapins' = 113252
	'about_Quoting_Rules' = 113253
	'about_Redirection' = 113254
	'about_Ref' = 113255
	'about_Regular_Expressions' = 113256
	'about_Remote' = 135182
	'about_Remote_FAQ' = 135183
	'about_Remote_Jobs' = 135184
	'about_Remote_Output' = 135185
	'about_Remote_Requirements' = 135187
	'about_Remote_Troubleshooting' = 135188
	'about_Requires' = 135190
	'about_Reserved_Words' = 113258
	'about_Return' = 136587
	'about_Scopes' = 113260
	'about_Script_Blocks' = 113261
	'about_Script_Internationalization' = 113262
	'about_Scripts' = 144310
	'about_Session_Configurations' = 145152
	'about_Signing' = 113268
	'about_Special_Characters' = 113269
	'about_Split' = 113270
	'about_Switch' = 113271
	'about_Throw' = 145153
	'about_Transactions' = 135192
	'about_Trap' = 136586
	'about_Try_Catch_Finally' = 113444
	'about_Type_Operators' = 113273
	'about_Types.ps1xml' = 113274
	'about_Variables' = 157591
	'about_While' = 113275
	'about_Wildcards' = 113276
	'about_Windows_Powershell_2.0' = 113247
	'about_Windows_PowerShell_ISE' = 135178
	'about_WMI_Cmdlets' = 145766
	'about_WS-Management_Cmdlets' = 145774
};
$PowerShellAboutTopicsTranslateRules = @( & {
	foreach ( $PowerShellAboutTopic in $PowerShellAboutTopics.Keys ) {
		$h = Get-Help $PowerShellAboutTopic -Full;
		@{
			template = New-Object `
				-TypeName System.Text.RegularExpressions.Regex `
				-ArgumentList `
					"(?<!\w|[`[])$PowerShellAboutTopic(?!\w)" `
					, (
						[System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
						-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
					)
			;
			expression = "[$PowerShellAboutTopic](${PowerShellBaseHelpUrl}$($PowerShellAboutTopics.$PowerShellAboutTopic) `"$($h.Synopsis)...`")";
		};
	}
});

$BasicTranslateRules = `
	  @{ template=[System.Text.RegularExpressions.Regex]"[ `t]*`r?`n"; expression="`r`n" } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<=(`r?`n){2})(`r?`n)*"; expression='' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortHTTP}"; expression='<http://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURLShortFTP}"; expression='<ftp://$0>' } `
	, @{ template=[System.Text.RegularExpressions.Regex]"(?<![<]|[`]][(])${reURL}"; expression='<$0>' } `
	+ $PowerShellAboutTopicsTranslateRules
;
$AdditionalLinksTranslateRules = `
	  @{ template=[System.Text.RegularExpressions.Regex]"^${reURL}\s+(?<description>.*)"; expression='[${description}](${url})' } `
;

Function Expand-Definitions {
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
		[AllowEmptyString()]
		$InputObject
	,
		[Parameter(
			Mandatory=$true
		)]
		[Array]
		$TranslateRules
	)

	process {
		if ( -not [String]::IsNullOrEmpty( $InputObject ) ) {
			foreach( $Rule in $TranslateRules ) {
				$InputObject = $InputObject -replace $Rule.Template, $Rule.Expression;
			};
		};
		return $InputObject;
	}
}

Function Get-FunctionsReferenceTranslateRules {
	<#
		.Synopsis
			Данная функция возвращает правила формирования ссылок на функции модуля по
			описателю модуля.
	#>
	
	param (
		# Описатель модуля
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
		)]
		[PSModuleInfo]
		$ModuleInfo
	,
		# Генерировать правила для формирования ссылок как на функции внешнего модуля
		[switch]
		$AsExternalModule
	)

	process {
		$ModuleInfo.ExportedFunctions.Values `
		| % {
			@{
				template = New-Object `
					-TypeName System.Text.RegularExpressions.Regex `
					-ArgumentList `
						"(?<!\w|[`[#]|`t+.*?)(?<func>$($_.Name))(?!\w)" `
						, (
							[System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
							-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
						)
				;
				expression = "[$($_.Name)][]";
			};
		};
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
			
			Описание может быть сгенерировано функцией Get-Readme для модуля, функции, внешего сценария.
		.Role
			Everyone
		.Notes
		.Inputs
			System.Management.Automation.PSModuleInfo
			Описатели модулей. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Module.
		.Inputs
			System.Management.Automation.CmdletInfo
			Через конвейер функция принимает описатели командлет. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Inputs
			System.Management.Automation.FunctionInfo
			Через конвейер функция принимает описатели функций. Именно для них и будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Inputs
			System.Management.Automation.ExternalScriptInfo
			Через конвейер функция принимает описатели внешних сценариев. Именно для них и будет сгенерирован readme.md. 
		.Outputs
			String
			Содержимое readme.md.
		.Link
			http://daringfireball.net/projects/markdown/syntax
			MarkDown (md) Syntax
		.Link
			about_comment_based_help
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
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -OutDefaultFile -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )
			Генерация readme.md файла для модуля `ITG.Yandex.DnsServer` 
			в каталоге модуля `ITG.Yandex.DnsServer`, при этом все упоминания
			функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
			`ITG.WinAPI.User32`	так же будут заменены перекрёстными ссылками
			на readme.md файлы указанных модулей.
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
		# выводить readme в файл readme.md в каталоге модуля
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
		# Перечень модулей, упоминания функций которых будут заменены на ссылки
		[Parameter(
			Mandatory=$false
		)]
		[PSModuleInfo[]]
		$ReferencedModules = @()
	,
		# Правила для обработки readme регулярными выражениями. Задавать явно не требуется,
		# используется параметр в реккурсивных вызовах
		[Parameter(
			Mandatory=$false
		)]
		[Hashtable[]]
		$TranslateRules = $BasicTranslateRules
	,
		# Генерировать только краткое описание
		[switch]
		[Alias('Short')]
		$ShortDescription
	)

	process {
		switch ( $PsCmdlet.ParameterSetName ) {
			'ModuleInfo' {
				$TranslateRules += @( Get-FunctionsReferenceTranslateRules -ModuleInfo $ModuleInfo );
				$TranslateRules += @( `
					$ReferencedModules `
					| Get-FunctionsReferenceTranslateRules -AsExternalModule `
				);
				$ReadMeContent = & { `
@"
$($ModuleInfo.Name)
$($ModuleInfo.Name -replace '.','=')

$( $ModuleInfo.Description | Expand-Definitions -TranslateRules $TranslateRules )

Версия модуля: **$( $ModuleInfo.Version.ToString() )**
"@
					if ( $ModuleInfo.ExportedFunctions ) {
@"

Функции модуля
--------------

"@
						# генерация перечня функций
						$ModuleInfo.ExportedFunctions.Values `
						| Sort-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
							, @{ Expression={ ( $_.Name -split '-' )[0] } } `
						| Group-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
						| % {
							$_.Group `
							| % {
@"
[$($_.Name)]: <#$($_.Name)>
"@
							};
						};
						# генерация краткого описания функций
						$ModuleInfo.ExportedFunctions.Values `
						| Sort-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
							, @{ Expression={ ( $_.Name -split '-' )[0] } } `
						| Group-Object -Property `
							@{ Expression={ ( $_.Name -split '-' )[1] } } `
						| % {
							if ( $_.Name ) {
@"

### $($_.Name)
"@
							};
							$_.Group `
							| % {
								$_ `
								| Get-Readme `
									-ShortDescription `
									-TranslateRules $TranslateRules `
								;
								if ( -not $ShortDescription ) {
@"

Подробнее - [$($_.Name)][].
"@
								};
							};
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
								-TranslateRules $TranslateRules `
							;
						};
					};
					# генерируем ссылки на функции других модулей ($ReferencedModules)
					if ( $ReferencedModules ) { `
@"

---------------------------------------
"@
						$ReferencedModules `
						| % {
							$ReferencedModule = $_;
							$ReferencedModule.ExportedFunctions.Values `
							| Sort-Object -Property `
								@{ Expression={ ( $_.Name -split '-' )[1] } } `
								, @{ Expression={ ( $_.Name -split '-' )[0] } } `
							| % {
@"
[$($_.Name)]: <${ReferencedModule}#$($_.Name)>
"@
							};
						};
					};
				} `
				| Out-String `
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
					if ( $ShortDescription ) {
@"

#### Обзор [$($FunctionInfo.Name)][]

"@
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
@"

#### $($FunctionInfo.Name)

"@
						if ( $Help.Description ) {
							$Help.Description `
							| Select-Object -ExpandProperty Text `
							| Expand-Definitions -TranslateRules $TranslateRules `
							;
						} else {
							$Help.Synopsis `
							| Expand-Definitions -TranslateRules $TranslateRules `
							;
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
							$Description = `
								$Help.Functionality `
								| Expand-Definitions -TranslateRules $TranslateRules `
							;
@"

##### Функциональность

$Description
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
								$Description = `
									$_.type.name `
									| Expand-Definitions -TranslateRules $TranslateRules `
								;
@"

$Description
"@
							};
						};
						if ( $Help.returnValues ) {
@"

##### Передаваемые по конвейеру данные
"@
							$Help.returnValues.returnValue `
							| % {
								$Description = `
									$_.type.name `
									| Expand-Definitions -TranslateRules $TranslateRules `
								;
@"

$Description
"@
							};
						};
						if ( $Help.Parameters ) {
							$Description = `
								( $Help.Parameters | Out-String ) `
								-replace '<CommonParameters>', '-<CommonParameters>' `
								-replace '(?m)^\p{Z}{4}-(.+)?\s*?$', '- `$1`' `
								| Expand-Definitions -TranslateRules $TranslateRules `
							;
@"

##### Параметры
$Description
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
								).Trim( ' ', (("`t").Normalize()) ) `
								| Expand-Definitions -TranslateRules $TranslateRules `
								;
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
									| Expand-Definitions -TranslateRules $AdditionalLinksTranslateRules `
									| Expand-Definitions -TranslateRules $TranslateRules `
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