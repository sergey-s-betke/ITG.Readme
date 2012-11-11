ITG.Utils
=========

Набор вспомогательных командлет и функций для сценариев PowerShell.

Функции модуля
--------------
			
### CustomMember
			
#### Add-CustomMember

Преобразование однотипных объектов со свойствами key и value в единый объект, 
свойства которого определены поданными на конвейер парами.

Add-CustomMember [-Name] <String> [-Value] <Object> [-Force] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
### ModuleReadme
			
#### Get-ModuleReadme

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям. 
Файл предназначен, в частности, для размещения в репозиториях github.

Get-ModuleReadme [-Module] <PSModuleInfo> [-OutDefaultFile] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
### Pair
			
#### Add-Pair

Преобразование / добавление однотипных объектов со свойствами key и value в hashtable / любой другой словарь.

Add-Pair [-Key] <String> [-Value] <Object> [-InputObject <IDictionary>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

			
#### Get-Pair

Конвертация таблицы транслитерации и любых других словарей в массив объектов с целью дальнейшей сериализации.

Get-Pair [-InputObject] <IDictionary> [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]

