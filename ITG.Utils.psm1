function ConvertFrom-Dictionary {
	<#
		.Synopsis
			Конвертация таблицы транслитерации и любых других словарей в массив объектов
			с целью дальнейшей сериализации.
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| ConvertFrom-Dictionary `
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

New-Alias -Name Get-Pair -Value ConvertFrom-Dictionary;

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
			| ConvertFrom-Dictionary `
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
			| ConvertFrom-Dictionary `
			| Add-Pair -InputObject (@{a=2;zzzzzzzzzzzz=3}) -PassThru
		.Example
			@{
				'А'='A';
				'Б'='B';
				'В'='V';
				'Г'='G';
			} `
			| Add-Pair -key zzzzzzzzzzzz -value 3 -PassThru
		.Example
			Add-Pair -InputObject $test -key prop -value 'val' -PassThru;
	#>
	[CmdletBinding(
		DefaultParameterSetName="NewObject"
	)]
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
		# Тип словаря, будет использован при создании нового словаря.
		[Parameter(
			Mandatory=$false
			, ParameterSetName="NewObject"
		)]
		[Type]
		$TypeName = [HashTable]
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
		$InputObject = (&{
			if ( -not $_ ) {
				if ( $PSCmdlet.ParameterSet -eq 'NewObject' ) { New-Object -TypeName $TypeName } `
				else { $InputObject };
			} `
			elseif ( $_ -is [System.Collections.IDictionary] ) { $_ } `
			else { $res } `
		});
        $InputObject.Add( $Key, $Value );
		if ( 
            $PassThru `
            -and ( ( -not $_ ) -or ( $_ -is [System.Collections.IDictionary] ) ) 
        ) {
			return $InputObject;
		};
	}
	end {
		if ( $PassThru ) { return $res; };
	}
}

New-Alias -Name ConvertTo-Dictionary -Value Add-Pair;

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

Export-ModuleMember `
	-Alias `
		Get-Pair `
		, ConvertTo-Dictionary `
	-Function `
		ConvertFrom-Dictionary `
		, Add-Pair `
		, Add-CustomMember `
;