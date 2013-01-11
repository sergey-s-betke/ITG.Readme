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

$reOnlineHelpLinkCheck = New-Object System.Text.RegularExpressions.Regex -ArgumentList `
	"^${reURL}`$" `
	, ( [System.Text.RegularExpressions.RegexOptions]::Singleline ) `
;

Filter ConvertTo-TranslateRule {
	<#
		.Synopsis
			Преобразует правила выделения внешних ссылок, переданных по конвейеру в различных форматах, в унифицированный формат
			для последующей инициализации транслятора `$Translator` (через Use-TranslateRule).
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

Function Use-TranslateRule {
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
					| ForEach-Object `
						-Begin {
							$res = @{};
						} `
						-Process {
							$res.Add( $_.Name, $_.Group[0] );
						} `
						-End {
							$res;
						} `
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
			| ForEach-Object `
				-Begin {
					$res = @{};
				} `
				-Process {
					$res.Add( $_.Name, $_.Group[0] );
				} `
				-End {
					$res;
				} `
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
						if ( $Translator.RegExpResults.$RuleType.expression -eq $null ) {
							return ( & "MatchEvaluatorFor$RuleType" $Match );
						} else {
							if ( $ruleType -eq 'mdRef' ) {
								$a=1;
							};
							return $Match.Result( $Translator.RegExpResults.$RuleType.expression );
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
	$aboutTopic = Get-Help `
		-Category HelpFile `
		-Name $id `
		-Full `
		-ErrorAction SilentlyContinue `
	;
	$title = $aboutTopic.Synopsis;
	if ( $title -match '[^.]\s*$' ) {
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
	"(?<=^\s*)(?<mdRef>\[(?<id>.+?)\]:\s+(?:<$reURL>|$reURL)(?:\s+$reMDRefTitle)?)(?=\s*$)" `
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
		-url "<$( $Translator.TokenRules.func.$id.moduleName )#${id}>" `
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
		-url $Translator.TokenRules.tag.$id.url `
		-title $Translator.TokenRules.tag.$id.title `
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
- $Description
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
- $Description
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

##### См. также

"@
							$Help.relatedLinks.navigationLink `
							| ? { $_.uri } `
							| % {
								# обрабатываем ссылки на online версию справки
								if ( $_.uri -match $reOnlineHelpLinkCheck ) {
@"
- [$( & { if ( $_.LinkText ) { $_.LinkText } else { 'Online версия справки' } } )]($( $_.uri ))
"@
								} else {
									Write-Warning `
										-Message @"
Обнаружена ошибка при оформлении раздела .Link в справке к функции $( $FunctionInfo.Name ).
Если содержание указанного раздела начинается с URL, то оно трактуется как ссылка на online 
версию справки. И не может содержать ничего, кроме URL.

Раздел с ошибочным содержанием:

	$( $_.uri )
	
"@ `
									;
								};
							};
							$Help.relatedLinks.navigationLink `
							| ? { -not $_.uri } `
							| % { $_.LinkText } `
							| % {
								# обрабатываем прочие ссылки
								$Link = `
									$_ `
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
			System.Management.Automation.PSModuleInfo.
			Описатели модулей, для которых будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Module.
		.Inputs
			System.Management.Automation.ExternalScriptInfo.
			Описатели сценариев, для которых будет сгенерирован readme.md. 
		.Inputs
			System.Management.Automation.CmdletInfo.
			Описатели командлет, для которых будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Inputs
			System.Management.Automation.FunctionInfo.
			Описатели функций, для которых будет сгенерирован readme.md. 
			Получены описатели могут быть через Get-Command.
		.Outputs
			String.
			Содержимое readme.md.
		.Link
			[MarkDown]: <http://daringfireball.net/projects/markdown/syntax> "MarkDown (md) Syntax"
		.Link
			about_comment_based_help
		.Link
			[Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)
		.Link
			http://github.com/IT-Service/ITG.Readme#Get-Readme
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
		| Use-TranslateRule `
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

Filter Split-Para {
	<#
		.Synopsis
			Делит переданный текст на абзацы по правилам MarkDown. В качестве границы
			абзацев - пустая строка. Текст в пределах абзаца объединяет в одну строку.
	#>
	param (
		[Parameter(
			Mandatory = $true
			, ValueFromPipeline = $true
		)]
		[String]
		[AllowEmptyString()]
		[Alias('Text')]
		$InputObject
	)
	
	$InputObject -split '(?:[ \t]*\r?\n[ \t]*){2,}' `
	| % {
		$_ -replace '(?:[ \t]*\r?\n[ \t]*)', ' ' `
		 	-replace '[ \t]+$', '' `
		;
	};
}

$HelpXMLNS = @{
	msh='http://msh';
	maml='http://schemas.microsoft.com/maml/2004/10';
	command='http://schemas.microsoft.com/maml/dev/command/2004/10';
	dev='http://schemas.microsoft.com/maml/dev/2004/10';
	MSHelp='http://msdn.microsoft.com/mshelp'
};

Function DoTextElement( $HelpContent, $Root, $Prefix, $El, $NS, $Txt ) {
	if ( $Txt ) {
		$null = $Root.AppendChild(
			$HelpContent.CreateElement( $Prefix, $El, $NS )
		).AppendChild(
			$HelpContent.CreateTextNode( $Txt )
		);
	};
};

Function DoNameElement( $HelpContent, $Root, $Txt ) {
	DoTextElement $HelpContent $Root 'maml' 'name' ( $HelpXMLNS.maml ) $Txt;
};

Function DoParaElement( $HelpContent, $Root, $El, $Description ) {
	if ( $Description ) {
		$DescriptionEl = $Root.AppendChild(
			$HelpContent.CreateElement( 'maml', $El, ( $HelpXMLNS.maml ) )
		);
		$Description `
		| Split-Para `
		| % {
			DoTextElement $HelpContent $DescriptionEl 'maml' 'para' ( $HelpXMLNS.maml ) $_;
		};
	};
};

Function DoDescription( $HelpContent, $Root, $Description ) {
	DoParaElement $HelpContent $Root 'description' $Description;
};

Function DoValuesList( $HelpContent, $Root, $Help, $ListId, $ListItemId ) {
	if ( $Help.$ListId ) {
		$List = $Root.AppendChild(
			$HelpContent.CreateElement( '', $ListId, ( $HelpXMLNS.command ) )
		);
		$Help.$ListId.$ListItemId `
		| % {
			$Txt = @( $_.type.name -split '\r?\n' );
			$TypeName = $Txt[0];

			$ItemEl = $List.AppendChild(
				$HelpContent.CreateElement( '', $ListItemId, ( $HelpXMLNS.command ) )
			).AppendChild(
				( $DevType = $HelpContent.CreateElement( 'dev', 'type', ( $HelpXMLNS.dev ) ) )
			);
			DoTextElement $HelpContent $DevType 'maml' 'name' ( $HelpXMLNS.maml ) $TypeName;
			DoTextElement $HelpContent $DevType 'maml' 'uri' ( $HelpXMLNS.maml ) ( $_.type.uri );

			if ( $_.type.description ) {
				$TypeDescription = $_.type.description | Select-Object -ExpandProperty Text;
			} elseif ( $Txt.Count -gt 1 ) {
				$TypeDescription = $Txt[1..( $Txt.Count-1 )] | Out-String;
			} else {
				$TypeDescription = '';
			};
			DoDescription $HelpContent $DevType $TypeDescription;

			if ( $_.Description ) {
				$TypeDescription = $_.Description | Select-Object -ExpandProperty Text;
			};
			DoDescription $HelpContent $ItemEl $TypeDescription;
		};
	};
};

Function DoParaList( $HelpContent, $Root, $Help, $ListId, $ListItemId ) {
	if ( $Help.$ListId ) {
		$List = $Root.AppendChild(
			$HelpContent.CreateElement( 'maml', $ListId, ( $HelpXMLNS.maml ) )
		);
		$Help.$ListId.$ListItemId `
		| % {
			DoParaElement $HelpContent $List $ListItemId ( $_.Text );
		};
	};
};

Function Get-InternalHelpXML {
	<#
		.Synopsis
			Get-HelpXML является лишь обёрткой (proxy функцией) к данной функции, 
			непосредственно подготовка help.xml выполняется данной функцией.
		.ForwardHelpTargetName
			Get-HelpXML
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
		# Описатель функции
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipeline=$true
			, ParameterSetName='FunctionInfo'
		)]
		[System.Management.Automation.FunctionInfo]
		$FunctionInfo
	)

	process {
		trap {
			break;
		};
		switch ( $PsCmdlet.ParameterSetName ) {
			'ModuleInfo' {
				[System.Xml.XmlDocument]$HelpContent = @"
<!-- Генератор: ITG.Readme (http://github.com/IT-Service/ITG.Readme). -->
<helpItems
	xmlns="$( $HelpXMLNS.msh )"
	xmlns:maml="$( $HelpXMLNS.maml )"
	xmlns:command="$( $HelpXMLNS.command )" 
	xmlns:dev="$( $HelpXMLNS.dev )"
	xmlns:MSHelp="$( $HelpXMLNS.MSHelp )"
	schema="maml"
/>
"@
				if ( $ModuleInfo.ExportedFunctions ) {
					$ModuleInfo.ExportedFunctions.Values `
					| Get-InternalHelpXML `
					| % {
						$null = $HelpContent.DocumentElement.AppendChild( $HelpContent.ImportNode( $_.DocumentElement, $true ) );
					};
				};
				return $HelpContent;
			}
			'FunctionInfo' {
				$ModuleManifestPath = Join-Path `
					-Path ( Split-Path ( $FunctionInfo.Module.Path ) -Parent ) `
					-ChildPath "$( $FunctionInfo.Module.Name ).psd1" `
				;
				if ( -not ( Test-Path -LiteralPath $ModuleManifestPath ) ) {
					Write-Error `
						-Message "Не обнаружен манифест ($ModuleManifestPath) модуля. XML справка может быть получена только при наличии манифеста." `
						-Category ResourceUnavailable `
						-CategoryActivity 'Загрузка манифеста модуля' `
						-CategoryReason 'Не обнаружен манифест модуля.' `
						-CategoryTargetName ( $FunctionInfo.Module.Name ) `
						-TargetObject ( $FunctionInfo.Module ) `
						-RecommendedAction 'Создайте .psd1 манифест к модулю и разместите его в каталоге модуля.' `
					;
					return;
				};
				$Module = Invoke-Expression ( ( Get-Content -LiteralPath $ModuleManifestPath -ReadCount 0 ) -join "`r`n" ) ;
				
				[xml]$HelpContent = @"
<command
	xmlns:msh="$( $HelpXMLNS.msh )"
	xmlns:maml="$( $HelpXMLNS.maml )"
	xmlns="$( $HelpXMLNS.command )" 
	xmlns:dev="$( $HelpXMLNS.dev )"
	xmlns:MSHelp="$( $HelpXMLNS.MSHelp )"
/>
"@
				$Command = $HelpContent.DocumentElement;
				
				$Details = $Command.AppendChild(
					$HelpContent.CreateElement( '', 'details', ( $HelpXMLNS.command ) )
				);
				DoTextElement $HelpContent $Details '' 'name' ( $HelpXMLNS.command ) ( $FunctionInfo.Name );

				$NameParts = @( $FunctionInfo.Name -split '-' );
				if ( $NameParts.Count -eq 2 ) {
					DoTextElement $HelpContent $Details '' 'verb' ( $HelpXMLNS.command ) ( $NameParts[0] );
					DoTextElement $HelpContent $Details '' 'noun' ( $HelpXMLNS.command ) ( $NameParts[1] );
				};

				$Help = $( $FunctionInfo | Get-Help -Full );

				DoDescription $HelpContent $Details ( $Help.Synopsis );
				DoParaElement $HelpContent $Details 'copyright' ( $Module.Copyright );
				DoTextElement $HelpContent $Details 'dev' 'version' ( $HelpXMLNS.dev ) ( $Module.ModuleVersion );
				DoTextElement $HelpContent $Details '' 'component' ( $HelpXMLNS.command ) ( $Help.Component );
				DoTextElement $HelpContent $Details '' 'functionality' ( $HelpXMLNS.command ) ( $Help.Functionality );
				DoTextElement $HelpContent $Details '' 'role' ( $HelpXMLNS.command ) ( $Help.Role );
				DoDescription $HelpContent $Command ( $Help.Description | Select-Object -ExpandProperty Text );

				if ( $Help.Syntax ) {
					$null = $Command.AppendChild(
						( $Syntax = $HelpContent.CreateElement( '', 'syntax', ( $HelpXMLNS.command ) ) )
					);
					$Help.Syntax.SyntaxItem `
					| % {
						$SyntaxItem = $Syntax.AppendChild(
							$HelpContent.CreateElement( '', 'syntaxItem', ( $HelpXMLNS.command ) )
						);
						DoNameElement $HelpContent $SyntaxItem ( $FunctionInfo.Name );
						
						$_.Parameter `
						| % {
							$Parameter = $SyntaxItem.AppendChild(
								$HelpContent.CreateElement( '', 'parameter', ( $HelpXMLNS.command ) )
							);
							DoNameElement $HelpContent $Parameter ( $_.Name );
							$Parameter.SetAttribute( 'required', ( $_.Required ) );
							$Parameter.SetAttribute( 'position', ( $_.Position ) );
							$Parameter.SetAttribute( 'pipelineInput', ( $_.PipelineInput ) );
							if ( $_.variableLength ) {
								$Parameter.SetAttribute( 'variableLength', ( $_.variableLength ) );
							};
							if ( $_.globbing ) {
								$Parameter.SetAttribute( 'globbing', ( $_.globbing ) );
							};

							if ( $_.parameterValue ) {
								$null = $Parameter.AppendChild(
									( $ParameterValue = $HelpContent.CreateElement( '', 'parameterValue', ( $HelpXMLNS.command ) ) )
								).AppendChild(
									$HelpContent.CreateTextNode( ( $_.parameterValue ) )
								);
								$ParameterValue.SetAttribute( 'required', ( $_.Required ) );
								if ( $_.variableLength ) {
									$ParameterValue.SetAttribute( 'variableLength', ( $_.variableLength ) );
								};
							};
						};
					};
				};

				if ( $Help.Parameters ) {
					$null = $Command.AppendChild(
						( $Parameters = $HelpContent.CreateElement( '', 'parameters', ( $HelpXMLNS.command ) ) )
					);
					$Help.Parameters.Parameter `
					| % {
						$Parameter = $Parameters.AppendChild(
							$HelpContent.CreateElement( '', 'parameter', ( $HelpXMLNS.command ) )
						);
						DoNameElement $HelpContent $Parameter ( $_.Name );

						$Parameter.SetAttribute( 'required', ( $_.Required ) );
						$Parameter.SetAttribute( 'position', ( $_.Position ) );
						$Parameter.SetAttribute( 'pipelineInput', ( $_.PipelineInput ) );
						if ( $_.variableLength ) {
							$Parameter.SetAttribute( 'variableLength', ( $_.variableLength ) );
						};
						if ( $_.globbing ) {
							$Parameter.SetAttribute( 'globbing', ( $_.globbing ) );
						};

						DoDescription $HelpContent $Parameter ( $_.Description | Select-Object -ExpandProperty Text );
						
						if ( $_.parameterValue ) {
							$null = $Parameter.AppendChild(
								( $ParameterValue = $HelpContent.CreateElement( '', 'parameterValue', ( $HelpXMLNS.command ) ) )
							).AppendChild(
								$HelpContent.CreateTextNode( ( $_.parameterValue ) )
							);
							$ParameterValue.SetAttribute( 'required', $true );
							if ( $_.variableLength ) {
								$ParameterValue.SetAttribute( 'variableLength', ( $_.variableLength ) );
							};
						};
						
						DoTextElement $HelpContent $Parameter '' 'defaultValue' ( $HelpXMLNS.command ) ( $_.defaultValue );
						
#					    <dev:possibleValues>
#					      <dev:possibleValue>
#					        <dev:value> Value 1 </dev:value>
#					        <maml:description>
#					          <maml:para> Description 1 </maml:para>
#					        </maml:description>
#					      <dev:possibleValue>
#					    </dev:possibleValues>
#						http://msdn.microsoft.com/en-us/library/bb736339.aspx
					};
				};

				DoValuesList $HelpContent $Command $Help 'inputTypes' 'inputType';
				DoValuesList $HelpContent $Command $Help 'returnValues' 'returnValue';
				DoParaList $HelpContent $Command $Help 'alertSet' 'alert';
				
				if ( $Help.relatedLinks ) {
					$ListEl = $Command.AppendChild(
						$HelpContent.CreateElement( 'maml', 'relatedLinks', ( $HelpXMLNS.maml ) )
					);
					$Help.relatedLinks.navigationLink `
					| % {
						$ListItemEl = $ListEl.AppendChild(
							$HelpContent.CreateElement( 'maml', 'navigationLink', ( $HelpXMLNS.maml ) )
						);
						DoTextElement $HelpContent $ListItemEl 'maml' 'uri' ( $HelpXMLNS.maml ) ( $_.uri );
						DoTextElement $HelpContent $ListItemEl 'maml' 'linkText' ( $HelpXMLNS.maml ) ( $_.linkText );
					};
				};

#				if ( $Help.Examples ) {
#					$List = $Command.AppendChild(
#						$HelpContent.CreateElement( 'maml', 'relatedLinks', ( $HelpXMLNS.maml ) )
#					);
#					$Help.Examples.Example `
#					| % {
#						DoTextElement $HelpContent $List 'maml' 'uri' ( $HelpXMLNS.maml ) ( $_.uri );
#						DoTextElement $HelpContent $List 'maml' 'linkText' ( $HelpXMLNS.maml ) ( $_.linkText );
#					};
#				};

				return $HelpContent;
				
				$ReadMeContent = & { `
					$Help = ( $FunctionInfo | Get-Help -Full );
					if ( $ShortDescription ) {
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
					};
				};
				return $ReadMeContent;
			};
		};
	};
}

Function Get-HelpXML {
	<#
		.Synopsis
			Генерирует XML справку для переданного модуля, функции, командлеты.
		.Description
			Генерирует XML справку для переданного модуля, функции, командлеты.
			
			Кроме того, для модуля при указании ключа `-OutDefaultFile` данная
			функция создаст XML файл справки в каталоге модуля (точнее - в
			подкаталоге культуры, как того и требуют командлеты PowerShell, в
			частности - `Get-Help`).
		.Notes
			Необходимо дополнительное тестирование на PowerShell 3.
		.Role
			Everyone
		.Inputs
			System.Management.Automation.PSModuleInfo
			Описатели модулей. Именно для них и будет сгенерирована XML справка. 
			Получены описатели могут быть через `Get-Module`.
		.Inputs
			System.Management.Automation.FunctionInfo
			Описатели функций. Именно для них и будет сгенерирована XML справка. 
			Получены описатели могут быть через `Get-Command`.
		.Inputs
			System.Management.Automation.CmdletInfo
			Описатели командлет. Именно для них и будет сгенерирована XML справка. 
			Получены описатели могут быть через `Get-Command`.
		.Outputs
			System.Xml.XmlDocument
			Содержимое XML справки.
		.Link
			about_Comment_Based_Help
		.Link
			about_Updatable_Help
		.Link
			[Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)
		.Link
			http://github.com/IT-Service/ITG.Readme#Get-HelpXML
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-HelpXML -OutDefaultFile;
			Генерация xml файла справки для модуля `ITG.Yandex.DnsServer` 
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
		# выводить help в файл `<ModuleName>-Help.xml` в каталоге модуля
		[Parameter(
			ParameterSetName='ModuleInfo'
		)]
		[switch]
		$OutDefaultFile
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
	)

	process {
		trap {
			break;
		};
		$res = $PSBoundParameters.Remove( 'OutDefaultFile' );
		[System.Xml.XmlDocument]$HelpContent = Get-InternalHelpXML @PSBoundParameters;
		switch ( $PsCmdlet.ParameterSetName ) {
			'ModuleInfo' {
				if ( $OutDefaultFile ) {
					$RootHelpDir = Split-Path `
						-Path ( $ModuleInfo.Path ) `
						-Parent `
					;
					$CultureHelpDir = Join-Path `
						-Path $RootHelpDir `
						-ChildPath ( ( Get-Culture ).Name ) `
					;
					$HelpFileName = "$( Split-Path -Path ($ModuleInfo.Path) -Leaf )-help.xml";
					if ( -not ( Test-Path $CultureHelpDir ) ) {
						$res = New-Item `
							-Path $CultureHelpDir `
							-ItemType Directory `
						;
					};
					
					$Writer = [System.Xml.XmlWriter]::Create(
						( Join-Path `
							-Path $CultureHelpDir `
							-ChildPath $HelpFileName `
						) `
						, ( New-Object `
							-TypeName System.Xml.XmlWriterSettings `
							-Property @{
								Indent = $true;
								OmitXmlDeclaration = $false;
								NamespaceHandling = [System.Xml.NamespaceHandling]::OmitDuplicates;
								NewLineOnAttributes = $false;
								CloseOutput = $true;
								IndentChars = "`t";
							} `
						) `
					);
					$HelpContent.WriteTo( $Writer );
					$Writer.Close();

#					-ChildPath "$( ( Get-Culture ).Name )\$( $ModuleInfo.Name )_$( $ModuleInfo.GUID )_HelpInfo.xml" `
				} else {
					return $HelpContent;
				};
			}
			default {
				return $HelpContent;
			};
		};
	}
}

Export-ModuleMember `
	  Get-Readme `
	, Get-HelpXML `
;