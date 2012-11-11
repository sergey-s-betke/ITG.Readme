function Get-Pair {
	<#
		.Synopsis
			Конвертация таблицы транслитерации и любых других словарей в массив объектов с целью дальнейшей сериализации.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Get-Pair `
			;
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

function Add-Pair {
	<#
		.Synopsis
			Преобразование / добавление однотипных объектов со свойствами key и value в hashtable / любой другой словарь.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Get-Pair `
			| ? { 'А','Б' -contains $_.key } `
			| Add-Pair -PassThru `
			;
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Get-Pair `
			| Add-Pair -InputObject (@{a=2;zzzzzzzzzzzz=3}) -PassThru
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Add-Pair -key zzzzzzzzzzzz -value 3 -PassThru
	#>

	param (
		# Ключ key для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Key
	,
		# Значение Value для hashtable.
		[Parameter(
			Mandatory=$true
			, Position=1
			, ValueFromPipelineByPropertyName=$true
		)]
		$Value
	,
		# Исходный словарь, в который будут добавлены сопоставления.
		[Parameter(
			Mandatory=$false
			, ValueFromPipeline=$true
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject = @{}
	,
		[switch]
		$PassThru
	)

	begin {
		if ( $InputObject ) {
			$res = $InputObject;
		} else {
			$res = @{};
		};
	}
	process {
		if ( $_ -is [System.Collections.IDictionary] ) {
			$_.Add( $Key, $Value );
		} else {
			$res.Add( $Key, $Value );
		};
		if ( $PassThru -and ( $_ -is [System.Collections.IDictionary] ) ) {
			return $_;
		};
	}
	end {
		if ( $PassThru ) { return $res; };
	}
}

function Add-CustomMember {
	<#
		.Synopsis
			Преобразование однотипных объектов со свойствами key и value в единый объект,
			свойства которого определены поданными на конвейер парами.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Add-CustomMember `
			;
	#>
	
	[CmdletBinding(
	)]

	param (
		# Идентификатор свойства
		[Parameter(
			Mandatory=$true
			, Position=0
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		[Alias("Key")]
		$Name
	,
		# Значение Value для hashtable
		[Parameter(
			Mandatory=$true
			, Position=1
			, ValueFromPipelineByPropertyName=$true
		)]
		$Value
#	,
#		# Тип добавляемого члена объекта
#		[Parameter(
#			Mandatory=$false
#			, ValueFromPipelineByPropertyName=$true
#		)]
#		[System.Management.Automation.PSMemberTypes]
#		$MemberType = [System.Management.Automation.PSMemberTypes]::NoteProperty
#	,
#		# Исходный словарь, в который будут добавлены сопоставления.
#		[Parameter(
#			Mandatory=$false
#		)]
#		[PSObject]
#		$InputObject = ( New-Object -TypeName PSObject )
#	,
#		[switch]
#		$PassThru
	,
		[switch]
		$Force
	)

	begin {
#		if ( $InputObject ) {
#			$res = $InputObject;
#		} else {
			$res = New-Object -TypeName PSObject;
#		};
	}
	process {
#		if ( $res ) {
			Add-Member `
				-InputObject $res `
				-MemberType NoteProperty `
				@PSBoundParameters `
			;
#		} else {
#			Add-Member -MemberType NoteProperty @PSBoundParameters;
#		};
	}
	end {
#		if ( $PassThru ) {
			return $res;
#		};
	}
}

function Get-ModuleReadme {
	<#
		.Synopsis
			Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
			Файл предназначен, в частности, для размещения в репозиториях github.
		.Link
			http://daringfireball.net/projects/markdown/syntax
		.Example
			Get-Module 'ITG.Yandex.DnsServer' `
			| Get-ModuleReadme `
			| Out-File `
				-Path 'readme.md' `
				-Force `
				-Encoding 'UTF8' `
				-Width 1024 `
			;
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
		@"
$($Module.Name)
$($Module.Name -replace '.','=')

$($Module.Description)

Функции модуля
--------------
"@
		$Funcs = `
		Get-Command `
			-Module $Module `
		| % {
			$_ `
			| Add-Member -PassThru -Name Verb -MemberType NoteProperty -Value ( ( $_.Name -split '-')[0] ) `
			| Add-Member -PassThru -Name Noun -MemberType NoteProperty -Value ( ( $_.Name -split '-' )[1] ) `
		} `
		| Sort-Object Noun, Verb `
		;
		$Funcs `
		| Group-Object Noun `
		| % {
@"
			
### $($_.Name)
"@
			$_.Group `
			| % {
@"
			
#### $($_.Name)

$( ( $_ | Get-Help -Full ).Synopsis )

$(
				Get-Command `
					-Name $_.Name `
					-Module $Module `
					-Syntax `
)
"@
			};
		};
#		@"
#
#Подробное описание функций модуля
#---------------------------------
#"@
#		$Funcs `
#		| % {
#@"
#			
##### $($_.Name)
#
#"@
#			$_ | Get-Help -Full;
#		};
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
	Get-Pair `
	, Add-Pair `
	, Add-CustomMember `
	, Get-ModuleReadMe `
;
