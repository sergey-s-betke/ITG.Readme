function ConvertFrom-Dictonary {
	<#
		.Synopsis
		    Конвертация таблицы транслитерации (да и не только) в массив объектов с целью дальнейшей сериализации.
		.Parameter InputObject
		    Таблица транслитерации.
		.Example
		    @{
		        'А'='A';
		        'Б'='B';
		        'В'='V';
		        'Г'='G';
			} `
			| ConvertFrom-Dictonary `
			;
	#>
	
    
    param (
		# Исходный словарь для конвейеризации
		[Parameter(
			Mandatory=$true,
			Position=0,
			ValueFromPipeline=$true
		)]
		[AllowEmptyCollection()]
		[System.Collections.IDictionary]
		$InputObject = @{}
	)

	process {
		foreach ($key in $InputObject.keys) {
	        New-Object -TypeName PSObject `
			| Select-Object -Property `
				@{ Name='Key'; Expression={ $key } } `
				, @{ Name='Value'; Expression={ $InputObject[$key] } }
	        ;
		};
	}
}  

function ConvertTo-HashTable {
	<#
		.Synopsis
		    Преобразование однотипных объектов со свойствами key и value в hashtable.
		.Example
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
	#>

	param (
		# Ключ key для hashtable.
		[Parameter(
			Mandatory=$true,
			Position=0,
			ValueFromPipelineByPropertyName=$true
		)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Key
	,
		# Значение Value для hashtable.
		[Parameter(
			Mandatory=$true,
			Position=1,
			ValueFromPipelineByPropertyName=$true
		)]
		$Value
	)

	begin {
		$output = @{};
	}
	process {
		$output.Add( $key, $Value );
	}
	end {
		return $output;
	}
}  

Export-ModuleMember `
    ConvertFrom-Dictonary `
    , ConvertTo-HashTable `
;
