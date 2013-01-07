'ITG.RegExps' `
| Import-Module `
;

$Translator = @{
	RegExp = $null;
	RuleType = @();
	RegExpResults = @{};
	RegExpIds = @();
	Refs = @{};
	Rules = @{};
	TokenRules = @{};
};

$reTokenChar = '[-a-zA-Z0-9_]';
$reBeforeToken = "(?<!${reTokenChar}|^\t+.*?|(?:``.*?``)*?.*?``)";
$reAfterToken = "(?!${reTokenChar})";
$reBeforeURL = "(?<!${reTokenChar}|^\t+.*?|\(<?|<|(``.*?``)*?.*?``)";

$reRegExpId = New-Object System.Text.RegularExpressions.Regex -ArgumentList `
	'(?<=\(\?\<)(?<id>\w+)(?=\>)' `
	, ( [System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
		-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
	) `
;

$reEOLCheck = New-Object System.Text.RegularExpressions.Regex -ArgumentList `
	'(?<crlf>\r?\n)' `
	, ( [System.Text.RegularExpressions.RegexOptions]::Singleline ) `
;

Filter ConvertTo-TranslateRule {
	<#
		.Synopsis
			Преобразует правила выделения внешних ссылок, переданных по конвейеру в различных форматах, в унифицированный формат
			для последующей инициализации транслятора `$Translator` (через ConvertTo-Translator).
	#>
	param (
		[Parameter(
			Mandatory = $false
			, ValueFromPipeline = $true
		)]
		[Hashtable]
		$TranslateRule
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$ruleCategory = 'token'
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$ruleType
	,
		[Parameter(
			Mandatory = $true
			, ValueFromPipeline = $true
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		[Alias('Name')]
		$template
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipeline = $true
		)]
		[System.Management.Automation.FunctionInfo]
		$FunctionInfo
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$ModuleName
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$id
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$expression
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$url
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$title
	)
	
	if ( $TranslateRule ) {
		$res = $PSBoundParameters.Remove( 'TranslateRule' );
		$res = $PSBoundParameters.Remove( 'template' );
		return `
			New-Object PSObject -Property $TranslateRule `
			| ConvertTo-TranslateRule @PSBoundParameters `
		;
	} else {
		$PSBoundParameters.ruleCategory = $ruleCategory;
		if ( $FunctionInfo ) {
			$PSBoundParameters.ruleType = 'func';
		};
		if ( $ruleCategory -eq 'regExp' ) {
			if ( $template -match $reRegExpId ) {
				$PSBoundParameters.id = $Matches['id'];
			};
		};
		return New-Object PSObject -Property $PSBoundParameters;
	};
}

Function Add-EndReference {
	<#
		.Synopsis
			Добавляет в `$Translator` концевую ссылку, упоминание которой встречено в обрабатываемом тексте.
	#>
	param (
		[Parameter(
			Mandatory = $false
			, ValueFromPipeline = $true
		)]
		[Hashtable]
		$EndReference
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$id
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$url
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$title
	,
		[Parameter(
			Mandatory = $false
			, ValueFromPipelineByPropertyName = $true
		)]
		[String]
		$refType
	)
	
	process {
		if ( $EndReference ) {
			New-Object PSObject -Property $EndReference `
			| Add-EndReference `
			;
		} else {
			if ( -not $Translator.Refs.$id ) {
				$Translator.Refs.Add(
					$id
					, ( New-Object PSObject `
						-Property @{
							id = $id;
							refType = $refType;
							url = $url;
							title = $title;
						}
					)
				)
			};
		};
	}
}

Function Get-EndReference {
	<#
		.Synopsis
			Генерирует массив накопленных в `$Translator` концевых ссылок для включения в readme.
	#>
	$Translator.Refs.Values `
	| Group-Object -Property refType `
	| Sort-Object -Property Name `
	| % {
@"

"@
		$_.Group `
		| Sort-Object -Property id `
		| % {
			"[$( $_.id )]: $( $_.url )" `
			, ( & { if ( $_.title ) { "`"$( $_.title )`"" }; } ) `
			-join ' '
		};
	};
};

Function ConvertTo-Translator {
	<#
		.Synopsis
			Инициализирует объект `$Translator` набором правил трансляции, поступившим по конвейеру.
	#>
	param (
		# элементы словаря (правил словаря - в том числе)
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
		)]
		[PSObject]
		$TranslateRule
	)

	begin {
		$Translator.RegExp = $null;
		$Translator.RuleType = @();
		$Translator.RegExpResults = @{};
		$Translator.RegExpIds = @();
		$Translator.Refs = @{};
		$Translator.Rules = @{};
		$Translator.TokenRules = @{};

		$Rules = @();
	}
	process {
		$Rules += $TranslateRule;
	}
	end {
		$Translator.Rules = 
			$Rules `
			| Group-Object `
				-Property ruleCategory `
				-AsHashTable `
				-AsString `
		;
		$TokenRules = `
			$Translator.Rules.token `
			| Group-Object `
				-Property ruleType `
				-AsHashTable `
				-AsString `
		;
		foreach ( $ruleType in $TokenRules.Keys ) {
			$Translator.TokenRules.Add(
				$ruleType
				, (
					$TokenRules.$ruleType `
					| Group-Object `
						-Property template `
						-AsHashTable `
						-AsString `
				)
			);
		};
		$Translator.RegExp = New-Object `
			-TypeName System.Text.RegularExpressions.Regex `
			-ArgumentList `
				(
					(
						@( $Translator.Rules.regexp | Select-Object -ExpandProperty template ) `
						+ (
							$reBeforeToken `
							, '(?<token>' `
							, (
								(
									$Translator.Rules.token `
									| Group-Object -Property ruleType `
									| % {
										"(?<$( $_.Name )>$( ( $_.Group | % { $_.template } ) -join '|' ))";
									} `
								) -join '|' `
							) `
							, ')' `
							, $reAfterToken `
							-join '' `
						) `
					) -join '|' `
				) `
				, (
					[System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
					-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
					-bor [System.Text.RegularExpressions.RegexOptions]::ExplicitCapture `
				)
		;
		$Translator.RuleType = `
			$Translator.Rules.token `
			| Select-Object -ExpandProperty ruleType -Unique `
		;
		$Translator.RegExpIds = `
			$Translator.Rules.regexp `
			| Select-Object -ExpandProperty id -Unique `
		;
		$Translator.RegExpResults = `
			$Translator.Rules.regexp `
			| ? { $_.id } `
			| Group-Object `
				-Property id `
				-AsHashTable `
				-AsString `
		;
	}
}

Filter Expand-Definitions {
	<#
		.Synopsis
			Данная функция выделяет определения из подготовленного readme и оформляет их в соответствии со 
			словарём, использованным при подготовке транслятора.
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
	)

	if ( -not [String]::IsNullOrEmpty( $InputObject ) ) {
		$Translator.RegExp.Replace(
			( $reEOLCheck.Replace( $InputObject, "`r`n" ) ) `
			, {
				param( [System.Text.RegularExpressions.Match] $Match)
				foreach ( $RuleType in $Translator.RegExpIds ) {
					if ( $Match.Groups[$RuleType].Success ) {
						if ( $($Translator.RegExpResults.$RuleType).expression -eq $null ) {
							return ( & "MatchEvaluatorFor$RuleType" $Match );
						} else {
							if ( $ruleType -eq 'mdRef' ) {
								$a=1;
							};
							return $Match.Result( $($Translator.RegExpResults.$RuleType).expression );
						};
					}
				};
				foreach ( $RuleType in $Translator.RuleType ) {
					if ( $Match.Groups[$RuleType].Success ) {
						return ( & "MatchEvaluatorFor$RuleType" $Match );
					}
				};
			}
		);
	};
};

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

Function MatchEvaluatorForAbout( [System.Text.RegularExpressions.Match] $Match ) {
	$id = `
		$PowerShellAboutTopics.Keys `
		| ? { $_ -ieq ($Match.Groups['about'].Value) } `
	;
	Add-EndReferenceForAbout( $id );
	return "[${id}][]";
};

Function Add-EndReferenceForAbout( [String] $Id ) {
	$aboutTopic = Get-Help $id -Full;
	$title = $aboutTopic.Synopsis;
	if ( $title -notmatch '\.\s*$' ) {
		$title += '...';
	};
	Add-EndReference `
		-id $id `
		-url "http://go.microsoft.com/fwlink/?LinkID=$( $PowerShellAboutTopics[ $id ] )" `
		-title $title `
	;
};

Function MatchEvaluatorForAboutCP( [System.Text.RegularExpressions.Match] $Match ) {
	Add-EndReferenceForAbout( 'about_CommonParameters' );
	return '[`get-help about_CommonParameters`][about_CommonParameters]';
};

$PowerShellAboutTopicsTranslateRules = @(
	'about_[a-zA-Z_.]+?' `
	| ConvertTo-TranslateRule -ruleType 'about' `
);

# [test]: <http://novgaro.ru> "заголовок такой"
$reMDRefTitle = "(?:'(?<title>.+?)'|`"(?<title>.+?)`"|\((?<title>.+?)\))";
$reMDRef = New-Object System.Text.RegularExpressions.Regex -ArgumentList `
	"(?<=^\s*)(?<mdRef>\[(?<id>\w+)\]:\s+(?:<$reURL>|$reURL)(?:\s+$reMDRefTitle)?)(?=\s*$)" `
	, ( [System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
		-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
	) `
;
$reMDLink = New-Object System.Text.RegularExpressions.Regex -ArgumentList `
	"(?<mdLink>\[(?<id>.+?)\]\((?:<$reURL>|$reURL)\))" `
	, ( [System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
		-bor [System.Text.RegularExpressions.RegexOptions]::Multiline `
	) `
;

$BasicTranslateRules = `
	(
		  @{ template='(?<ts>[ \t]+)(?=\r?$)'; expression='' } `
		, @{ template='(?<=(\r?\n))(?<eol>(?:[ \t]*\r?\n)+)'; expression="`r`n" } `
		, @{ template='(?<aboutCP>"get-help about_CommonParameters")' } `
		, @{ template="${reMDRef}"; expression='[${id}][]' } `
		, @{ template="${reMDLink}"; expression='[${id}](${url})' } `
		, @{ template="${reBeforeURL}(?<fullUrl>${reURL})"; expression='<${fullUrl}>' } `
		, @{ template="${reBeforeURL}(?<wwwUrl>${reURLShortHTTP})"; expression='<http://${wwwUrl}>' } `
		, @{ template="${reBeforeURL}(?<ftpUrl>${reURLShortFTP})"; expression='<ftp://${ftpUrl}>' } `
		| ConvertTo-TranslateRule -ruleCategory regExp `
	) `
	+ $PowerShellAboutTopicsTranslateRules `
;

Function MatchEvaluatorForFunc( [System.Text.RegularExpressions.Match] $Match ) {
	$id = $Match.Groups['func'].Value;
	$title = ( ( Get-Help $id ).Synopsis -split '\s*\r?\n' ) -join ' ';
	Add-EndReference `
		-id $id `
		-url "<$( $( $Translator.TokenRules.func.$id ).moduleName )#${id}>" `
		-title $title `
	;
	return "[${id}][]";
};

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
		| ConvertTo-TranslateRule `
		;
	}
}

Function MatchEvaluatorForTag( [System.Text.RegularExpressions.Match] $Match ) {
	$id = $Match.Value;
	Add-EndReference `
		-id $id `
		-url "$( $( $Translator.TokenRules.tag.$id ).url )" `
		-title "$( $( $Translator.TokenRules.tag.$id ).title )" `
	;
	return "[${id}][]";
};

Function Get-TagReferenceTranslateRules {
	<#
		.Synopsis
			Данная функция возвращает правила замены терминов на ссылки [tag][] по найденным
			определениям типа `[test]: <http://novgaro.ru> "заголовок такой"`
	#>

	[CmdletBinding(
		DefaultParametersetName='ModuleInfo'
	)]

	param (
		# Описатель модуля
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
			, ParameterSetName='ModuleInfo'
		)]
		[PSModuleInfo]
		$ModuleInfo
	,
		# Описатель внешнего сценария
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
			, ParameterSetName='ExternalScriptInfo'
		)]
		[System.Management.Automation.ExternalScriptInfo]
		$ExternalScriptInfo
	,
		# Описатель функции
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
			, ParameterSetName='FunctionInfo'
		)]
		[System.Management.Automation.FunctionInfo]
		$FunctionInfo
	,
		# Текст для поиска ссылок
		[Parameter(
			Mandatory=$true
			, ValueFromPipeline=$true
			, ParameterSetName='StringInfo'
		)]
		[String]
		$Text
	)

	process {
		switch ( $PsCmdlet.ParameterSetName ) {
			'StringInfo' {
				$reMDRef.Matches( $Text ) `
				| % {
					@{
						template = ( $_.Groups['id'].Value );
						url = ( $_.Groups['url'].Value );
						title = ( $_.Groups['title'].Value );
					};
				} `
				| ConvertTo-TranslateRule `
					-ruleType 'tag' `
				;
			}
			'ModuleInfo' {
				$ModuleInfo.Description `
				| Get-TagReferenceTranslateRules;
				$ModuleInfo.ExportedFunctions.Values `
				| Get-TagReferenceTranslateRules;
			}
			'ExternalScriptInfo' {
			}
			'FunctionInfo' {
				$Help = $FunctionInfo | Get-Help -Full;
				$Help.Description `
				| Select-Object -ExpandProperty Text `
				| Get-TagReferenceTranslateRules `
				;
				$Help.relatedLinks `
				| Select-Object -ExpandProperty navigationLink `
				| ? { $_.LinkText } `
				| Select-Object -ExpandProperty LinkText `
				| Get-TagReferenceTranslateRules `
			};
		};
	}
}

Function Get-InternalReadme {
	<#
		.Synopsis
			Get-Readme является лишь обёрткой (proxy функцией) к данной функции, обеспечивающей
			подготовку правил трансляции терминов, непосредственно подготовка readme выполняется
			данной функцией.
		.ForwardHelpTargetName
			Get-Readme
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
		# Описатель функции
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
		# Генерировать только краткое описание
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

$( $ModuleInfo.Description | Expand-Definitions )

Версия модуля: **$( $ModuleInfo.Version.ToString() )**
"@
					if ( $ModuleInfo.ExportedFunctions ) {
@"

Функции модуля
--------------
"@
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
								| Get-InternalReadme `
									-ShortDescription `
								;
								if ( -not $ShortDescription ) {
@"

Подробнее - $( $_.Name | Expand-Definitions ).
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
							| Get-InternalReadme `
							;
						};
					};
				} `
				| Out-String `
				;
				return $ReadMeContent;
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

#### Обзор $( $FunctionInfo.Name | Expand-Definitions )

"@
						$Help.Synopsis `
						| Expand-Definitions `
						;
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
							| Expand-Definitions `
							;
						} else {
							$Help.Synopsis `
							| Expand-Definitions `
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
									| Expand-Definitions `
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
									| Expand-Definitions `
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
								-replace '(?m)(?<=^)\p{Z}{4}-([^\r\n]+)?(?=\s*$)', '- `$1`' `
								-replace '(?<=\S)[ \t]{2,}(?=\S)', ' ' `
								| Expand-Definitions `
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
								| Expand-Definitions `
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
									| Expand-Definitions `
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

Function Get-Readme {
	<#
		.Synopsis
			Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. 
			Файл предназначен, в частности, для размещения в репозиториях github.
		.Description
			Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. 
			Файл предназначен, в частности, для размещения в репозиториях github. 
			Описание может быть сгенерировано функцией Get-Readme для модуля, функции, внешего сценария.
		.Functionality
			Readme
		.Component
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
			[MarkDown]: <http://daringfireball.net/projects/markdown/syntax> "MarkDown (md) Syntax"
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
		# Описатель функции
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
		# Правила для обработки readme регулярными выражениями
		[Parameter(
			Mandatory=$false
		)]
		[Array]
		$TranslateRules = @()
	,
		# Генерировать только краткое описание
		[switch]
		[Alias('Short')]
		$ShortDescription
	)

	process {
		$TranslateRules += & {
			$ReferencedModules `
			| % {
				$_ | Get-FunctionsReferenceTranslateRules -AsExternalModule;
				$_ | Get-TagReferenceTranslateRules;
			};
			switch ( $PsCmdlet.ParameterSetName ) {
				'ModuleInfo' {
					$ModuleInfo `
					| % {
						$_ | Get-FunctionsReferenceTranslateRules;
						$_ | Get-TagReferenceTranslateRules;
					};
				}
				'ExternalScriptInfo' {
				}
				'FunctionInfo' {
				};
			};
		};
		$TranslateRules = `
			@(
				$TranslateRules `
				| ConvertTo-TranslateRule `
			) `
			+ $BasicTranslateRules `
		;

		$TranslateRules `
		| ConvertTo-Translator `
		;
		
		$res = $PSBoundParameters.Remove( 'TranslateRules' );
		$res = $PSBoundParameters.Remove( 'OutDefaultFile' );
		$ReadMeContent = `
			( # генерируем собственно readme с подготовленными правилами трансляции терминов
				Get-InternalReadme @PSBoundParameters `
			) `
			, (
				Get-EndReference
			) `
			, ( # генерируем ссылку на репозиторий данного модуля
@"

---------------------------------------

Генератор: [ITG.Readme](http://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").
"@ `
			) `
			| Out-String `
		;
		switch ( $PsCmdlet.ParameterSetName ) {
			'ModuleInfo' {
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
			default {
				return $ReadMeContent;
			};
		};
	}
}

Export-ModuleMember `
	Get-Readme `
;