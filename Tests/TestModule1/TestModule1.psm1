Function Get-AboutTestFunction {
	<#
		.Synopsis
			Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с MarkDown разметкой
			по данным модуля и комментариям к его функциям. 
		.Description
			Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с MarkDown разметкой
			по данным модуля и комментариям к его функциям.
			Для сохранения в файл используйте Set-AboutModule.
		.Functionality
			Readme
		.Role
			Everyone
		.Notes
		.Inputs
			System.Management.Automation.PSModuleInfo.
			Описатели модулей, для которых будет сгенерирован about.txt. 
			Получены описатели могут быть через Get-Module.
		.Outputs
			String.
			Содержимое about.txt.
		.Link
			https://github.com/IT-Service/ITG.Readme#Get-AboutModule
		.Link
			[MarkDown]: <http://daringfireball.net/projects/markdown/syntax> "MarkDown (md) Syntax"
		.Link
			about_comment_based_help
		.Link
			[Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)
		.Example
			Get-Module 'ITG.Yandex.DnsServer' | Get-AboutModule;
			Генерация содержимого about.txt файла для модуля `ITG.Yandex.DnsServer`.
	#>
	
	[CmdletBinding(
		DefaultParametersetName = 'ModuleInfo'
		, HelpUri = 'https://github.com/IT-Service/ITG.Readme#Get-AboutModule'
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
		# культура, для которой генерировать данные.
		[Parameter(
			Mandatory=$false
		)]
		[System.Globalization.CultureInfo]
		$UICulture = ( Get-Culture )
	,
		# Перечень модулей, упоминания функций которых будут заменены на ссылки
		[Parameter(
			Mandatory=$false
		)]
		[PSModuleInfo[]]
		[Alias('RequiredModules')]
		$ReferencedModules = @()
	)

	process {
	}
}

New-Alias `
	-Name Get-AboutTest `
	-Value Get-AboutTestFunction `
;

Export-ModuleMember `
	-Function `
		Get-AboutTestFunction `
	-Alias `
		Get-AboutTest `
;
