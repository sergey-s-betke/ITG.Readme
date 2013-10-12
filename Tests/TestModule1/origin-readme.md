TestModule1
===========

Обзор модуля, который будет включён в начало генерируемого readme.md файла.

Указанная в скобках ссылка должна быть преобразована в ссылку [markdown][] (см. [about_Comment_Based_Help][]).

В коде термины не должны быть преобразованы в ссылки:

	Get-Module 'ITG.Readme' `
	| Set-Readme `
	;

Здесь ссылка должна быть преобразована - Set-Readme, а здесь - `Set-Readme` - нет.

Вариант полной ссылки - [psake](https://github.com/psake/psake).


Версия модуля: **1.2.3**

ПОДДЕРЖИВАЮТСЯ КОМАНДЛЕТЫ
-------------------------

### AboutTestFunction

#### КРАТКОЕ ОПИСАНИЕ [Get-AboutTestFunction][]

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.

	Get-AboutTestFunction [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

ОПИСАНИЕ
--------

#### Get-AboutTestFunction

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.
Для сохранения в файл используйте Set-AboutModule.

##### ПСЕВДОНИМЫ

Get-AboutTest

##### СИНТАКСИС

	Get-AboutTestFunction [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

##### ВОЗМОЖНОСТИ

Readme

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Get-AboutTestFunction` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][].
Описатели модулей, для которых будет сгенерирован about.txt.
Получены описатели могут быть через [Get-Module][].

##### ВЫХОДНЫЕ ДАННЫЕ

- String.
Содержимое about.txt.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[CultureInfo] UICulture`
	культура, для которой генерировать данные.
	* Тип: [System.Globalization.CultureInfo][]
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `( Get-Culture )`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[PSModuleInfo[]] ReferencedModules`
	Перечень модулей, упоминания функций которых будут заменены на ссылки
	* Тип: [System.Management.Automation.PSModuleInfo][][]
	* Псевдонимы: RequiredModules
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `@()`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация содержимого about.txt файла для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | Get-AboutModule;

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Get-AboutModule)
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)


[about_Comment_Based_Help]: http://go.microsoft.com/fwlink/?LinkID=144309 "Describes how to write comment-based help topics for functions and scripts."
[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Describes the parameters that can be used with any cmdlet."
[Get-AboutTestFunction]: <../it-service/itg.readme#get-aboutmodule> "Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с MarkDown разметкой по данным модуля и комментариям к его функциям."
[Get-Module]: <http://go.microsoft.com/fwlink/?linkid=141552> "Gets the modules that have been imported or that can be imported into the current session."
[markdown]: http://daringfireball.net/projects/markdown/syntax "MarkDown (md) Syntax"
[System.Globalization.CultureInfo]: <http://msdn.microsoft.com/ru-ru/library/system.globalization.cultureinfo.aspx> "CultureInfo Class (System.Globalization)"
[System.Management.Automation.PSModuleInfo]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.psmoduleinfo.aspx> "PSModuleInfo Class (System.Management.Automation)"

---------------------------------------

Генератор: [ITG.Readme](https://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

