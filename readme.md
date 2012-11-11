ITG.Utils
=========

Набор вспомогательных командлет и функций для PowerShell.

Функции модуля
--------------
			
### Dictionary
			
#### ConvertFrom-Dictionary

Конвертация таблицы транслитерации и любых других словарей в массив объектов 
с целью дальнейшей сериализации.

ConvertFrom-Dictionary [-InputObject] <IDictionary> [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
### ModuleReadme
			
#### Get-ModuleReadme

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям. 
Файл предназначен, в частности, для размещения в репозиториях github.

Get-ModuleReadme [-Module] <PSModuleInfo> [-OutDefaultFile] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
### ObjectProperty
			
#### ConvertTo-ObjectProperty

Преобразование однотипных объектов со свойствами key и value в единый объект, 
свойства которого определены поданными на конвейер парами.

ConvertTo-ObjectProperty -Key <String> -Value <Object> [-TypeName <Type>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]
ConvertTo-ObjectProperty -Key <String> -Value <Object> [-InputObject <IDictionary>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
#### Set-ObjectProperty

Добавление либо изменение свойств объекта, поступающего по контейнеру

Set-ObjectProperty [-Key] <String> [-Value] <Object> -InputObject <Object> [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

