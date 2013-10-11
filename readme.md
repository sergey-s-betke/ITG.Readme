ITG.Readme
==========

Данный модуль предоставляет набор командлет для формирования **справочной системы** модулей
PowerShell, сценариев PowerShell:

- генерация **readme.md** (readme.txt) файла для модуля, сценария;
- генерация файла **about_ModuleName.txt** для модуля;
- генерация **xml справки** для модуля (включая .cab файлы, см. [about_Updatable_Help][]).

Для генерации указанных выше элементов справочной системы используется справка, построенная
на основе комментариев в тексте описываемого модуля, сценария (см. [about_Comment_Based_Help][]).

В качестве примера использования функционала данного модуля можно рассматривать справочную
систему этого же модуля. В частности, файла **readme.md** в корневом каталоге репозитория сгенерирован
следующим образом:

	Get-Module 'ITG.Readme' `
	| Set-Readme `
	;

Командлет [Set-Readme][] по умолчанию генерирует файл с именем `readme.md` в каталоге модуля.
Формат генерируемого Readme.MD файла - текстовый файл в кодировке UTF-8 с
разметкой [MarkDown][].

Хорошим тоном считается предоставлять локализованный файл с кратким описанием функциональности
модуля - **about_ModuleName.txt**. Данный файл должен быть размещён в подкаталоге культуры корневого
каталога описываемого модуля. Например, следующий код генерирует указанный файл для модуля `ITG.Readme`:

	Get-Module 'ITG.Readme' | Set-AboutModule;

В результате получаем файл `about_ITG.Readme.txt` в подкаталоге `ru-RU` корневого каталога модуля
`ITG.Readme`. Для чего? И вот для чего:

	Get-Help about_ITG.Readme

или

	Get-Module 'ITG.Readme' | Get-Help

выдаст содержимое созданного `about_ITG.Readme.txt` файла
в необходимом пользователю языке (естественно, если необходимая локализация есть в наличии).
Порядок традиционный: в первую очередь
осуществляется попытка обнаружить указанный выше файл в каталоге текущей культуры пользователя
(для русского языка - 'ru-RU'), если же такого подкаталога или файла в нём нет, тогда - по правилам
подбора наиболее подходящей локализации, вплоть до 'en-US'.

И на десерт - генерация обновляемой загружаемой **xml справки**:

	Get-Module 'ITG.Readme' `
	| Set-HelpXML -Cab -PassThru `
	| Set-HelpInfo `
	;

Чтобы понять, о чём идёт речь, следует изучить раздел справочной системы PowerShell [about_Comment_Based_Help][].
приведённый выше код генерирует локализуемую xml справку в подкаталогах культуры (в случает данного модуля -
`ru-RU\ITG.Readme-help.xml`), и при необходимости (параметр `-Cab`) генерирует загружаемый архив (файл
`help.cab\ITG.Readme_826e836c-d10c-4d4d-b86b-8b4a41829b00_ru-RU_HelpContent.cab`).

Для поддержки `Update-Help` ещё необходим файл `ITG.Readme_826e836c-d10c-4d4d-b86b-8b4a41829b00_HelpInfo.xml`,
который и генерируется командлетом [Set-HelpInfo][].

После того, как xml файлы справки сгенерированы, необходимо внести изменения в файлы модуля и его манифеста.
Эти действия так же могут быть выполнены сценарием:

	Get-Module 'ITG.Readme' `
	| Set-HelpXML -Cab -UpdateModule `
	| Set-HelpInfo -UpdateManifest `
	;

Функции данного модуля так же позволяют Вам генерировать перекрёстные ссылки на описания используемых
Вами функций. Например, данная ссылка - [Get-Command][] сгенерирована автоматически.
Ссылки формируются на описания функций и командлет модулей 'Microsoft.PowerShell.*', тех модулей, которые
Вы явно указали как необходимые в манифесте Вашего модуля (`RequiredModules`), а также на описания
функций тех модулей, что Вы явно указали в параметре `ReferencedModules`.

P.S. Надеюсь, функционал данного модуля будет Вам полезен и позволит обеспечить Ваши модули PowerShell
документацией с существенно меньшими трудозатратами.

Тестирование модуля и подготовка к публикации
---------------------------------------------

Для сборки модуля использую проект [psake](https://github.com/psake/psake). Для инициирования сборки используйте сценарий `build.ps1`.


Версия модуля: **2.3.1**

ПОДДЕРЖИВАЮТСЯ КОМАНДЛЕТЫ
-------------------------

### AboutModule

#### КРАТКОЕ ОПИСАНИЕ [Get-AboutModule][]

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.

	Get-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [Set-AboutModule][]

Генерирует файл `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.

	Set-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ReferencedModules <PSModuleInfo[]>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

### HelpInfo

#### КРАТКОЕ ОПИСАНИЕ [Get-HelpInfo][]

Возвращает HelpInfo.xml (как xml) для указанного модуля.

	Get-HelpInfo [-ModuleInfo] <PSModuleInfo> <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [New-HelpInfo][]

Генерирует HelpInfo XML для переданного модуля.

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [Set-HelpInfo][]

Генерирует HelpInfo XML для указанного модуля.

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] [-UpdateManifest] [-HelpInfoUri <Uri>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

### HelpXML

#### КРАТКОЕ ОПИСАНИЕ [Get-HelpXML][]

Возващает XML содержимое xml файла справки для переданного модуля.

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [New-HelpXML][]

Генерирует XML справку для переданного модуля, функции, командлеты.

	New-HelpXML [-ModuleInfo] <PSModuleInfo> <CommonParameters>

	New-HelpXML [-FunctionInfo] <CommandInfo> <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [Set-HelpXML][]

Генерирует XML файл справки для переданного модуля, функции, командлеты.

	Set-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-UpdateModule] [-Cab] [-PSCabPath <String>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-HelpXML [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

### Readme

#### КРАТКОЕ ОПИСАНИЕ [Get-Readme][]

Генерирует readme с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

#### КРАТКОЕ ОПИСАНИЕ [Set-Readme][]

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

	Set-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-Readme [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

ОПИСАНИЕ
--------

#### Get-AboutModule

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.
Для сохранения в файл используйте [Set-AboutModule][].

##### ПСЕВДОНИМЫ

Get-About

##### СИНТАКСИС

	Get-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

##### ВОЗМОЖНОСТИ

Readme

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Get-AboutModule` требуется роль **Everyone** для учётной записи,
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

#### Set-AboutModule

Генерирует файл `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям в подкаталоге указанной
культуры в каталоге модуля или в соответствии с указанным значением
параметра `Path`.

##### ПСЕВДОНИМЫ

Set-About

##### СИНТАКСИС

	Set-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ReferencedModules <PSModuleInfo[]>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### ВОЗМОЖНОСТИ

Readme

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Set-AboutModule` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][].
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Module][].

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

- `[String] PSPath`
	Путь для about.txt файла. По умолчанию - в подкаталоге указанной культуры.
	* Тип: [System.String][]
	* Псевдонимы: Path
	* Требуется? нет
	* Позиция? named
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

- `[SwitchParameter] PassThru`
	Передавать полученный по конвейеру описатель дальше
	

- `[SwitchParameter] WhatIf`
	* Псевдонимы: wi

- `[SwitchParameter] Confirm`
	* Псевдонимы: cf

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация `about_ITG.Yandex.DnsServer.txt` файла для модуля `ITG.Yandex.DnsServer`
в подкаталоге текущей культуры в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-AboutModule;

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Set-AboutModule)
- [Get-AboutModule][]
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

#### Get-HelpInfo

Вычисляет наименование и положение HelpInfo.xml файла для указанного модуля
и возвращает его содержимое. Если файл не обнаружен - возвращает пустую
xml "заготовку" HelpInfo.xml, но валидную.

##### СИНТАКСИС

	Get-HelpInfo [-ModuleInfo] <PSModuleInfo> <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Get-HelpInfo` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет возвращён манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### ВЫХОДНЫЕ ДАННЫЕ

- [System.Xml.XmlDocument][]
Содержимое XML манифеста (HelpInfo.xml) справки.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Возвращает xml манифест справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpInfo;

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Get-HelpInfo)
- [about_Updatable_Help][]
- [Set-HelpInfo][]
- [New-HelpInfo][]
- [How to Name a HelpInfo XML File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852748.aspx)
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### New-HelpInfo

Генерирует HelpInfo XML для переданного модуля, без записи в файл.
HelpInfo.XML по сути является манифестом для xml справки модуля.

##### СИНТАКСИС

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `New-HelpInfo` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет сгенерирован манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### ВЫХОДНЫЕ ДАННЫЕ

- [System.Xml.XmlDocument][]
Содержимое XML манифеста (HelpInfo.xml) справки.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[Uri] HelpContentUri`
	Ссылка для загрузки обновляемой справки. Смотрите [about_Updatable_Help][].
	Значение по умолчанию - url к репозиторию проекта на github.
	* Тип: [System.Uri][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация xml манифеста справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | New-HelpInfo;

##### ПРИМЕЧАНИЯ

Для записи HelpInfo.xml файла используйте [Set-HelpInfo][].

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#New-HelpInfo)
- [about_Updatable_Help][]
- [Set-HelpInfo][]
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Set-HelpInfo

Генерирует HelpInfo XML для переданного модуля, и
вносит изменения (в части текущей культуры) в существующий файл
HelpInfo.xml в каталоге модуля, либо создаёт новый файл.

##### СИНТАКСИС

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] [-UpdateManifest] [-HelpInfoUri <Uri>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Set-HelpInfo` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет сгенерирован манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### ВЫХОДНЫЕ ДАННЫЕ

- None.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[Uri] HelpContentUri`
	Ссылка для загрузки обновляемой справки. Смотрите [about_Updatable_Help][].
	Значение по умолчанию - url к репозиторию проекта на github.
	* Тип: [System.Uri][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] UpdateManifest`
	Обновлять или нет манифест модуля. Речь идёт о создании / обновлении параметра
	HelpInfoURI в манифесте, который как раз и должен указывать на HelpInfo.xml файл
	

- `[Uri] HelpInfoUri`
	Используется только совместно
	с `UpdateManifest`. Значение по умолчанию - url к репозиторию проекта на github.
	* Тип: [System.Uri][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] PassThru`
	Передавать полученный по конвейеру описатель дальше
	

- `[SwitchParameter] WhatIf`
	* Псевдонимы: wi

- `[SwitchParameter] Confirm`
	* Псевдонимы: cf

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Создание / модификация HelpInfo.xml файла для модуля `ITG.Yandex.DnsServer` в каталоге модуля.

		Set-HelpInfo -ModuleInfo ( Get-Module 'ITG.Yandex.DnsServer' );

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Set-HelpInfo)
- [about_Updatable_Help][]
- [Get-HelpInfo][]
- [New-HelpInfo][]
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Get-HelpXML

Возващает XML содержимое xml файла справки для переданного модуля.

##### СИНТАКСИС

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Get-HelpXML` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.

##### ВЫХОДНЫЕ ДАННЫЕ

- [System.Xml.XmlDocument][]
Содержимое XML справки.

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
	культура, для которой вернуть данные.
	* Тип: [System.Globalization.CultureInfo][]
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `( Get-Culture )`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[String] PSPath`
	Путь для xml файла справки
	* Тип: [System.String][]
	* Псевдонимы: Path
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Возвращает содержимое xml файла справки для модуля `ITG.Yandex.DnsServer`
в виде XML документа.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpXML;

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Get-HelpXML)
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### New-HelpXML

Генерирует XML справку для переданного модуля, функции, командлеты.

Для генерации / обновления .xml файла справки в каталоге модуля
используйте [Set-HelpXML][].

##### СИНТАКСИС

	New-HelpXML [-ModuleInfo] <PSModuleInfo> <CommonParameters>

	New-HelpXML [-FunctionInfo] <CommandInfo> <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `New-HelpXML` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.
- [System.Management.Automation.CommandInfo][]
Описатели функций. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.

##### ВЫХОДНЫЕ ДАННЫЕ

- [System.Xml.XmlDocument][]
Содержимое XML справки.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[CommandInfo] FunctionInfo`
	Описатель функции
	* Тип: [System.Management.Automation.CommandInfo][]
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация xml справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | New-HelpXML;

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#New-HelpXML)
- [about_Comment_Based_Help][]
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### Set-HelpXML

Генерирует XML файл справки для переданного модуля, функции, командлеты.

Кроме того, данная
функция создаст XML файл справки в каталоге модуля (точнее - в
подкаталоге культуры, как того и требуют командлеты PowerShell, в
частности - `Get-Help`).

##### СИНТАКСИС

	Set-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-UpdateModule] [-Cab] [-PSCabPath <String>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-HelpXML [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Set-HelpXML` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][]
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.
- [System.Management.Automation.CommandInfo][]
Описатели функций. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[CommandInfo] FunctionInfo`
	Описатель функции
	* Тип: [System.Management.Automation.CommandInfo][]
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

- `[String] PSPath`
	Путь для xml файла справки
	* Тип: [System.String][]
	* Псевдонимы: Path
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] UpdateModule`
	обновлять файл модуля - добавлять в файл модуля в комментарии к функциям модуля
	записи типа `.ExternalHelp ITG.Readme-help.xml`
	

- `[SwitchParameter] Cab`
	генерировать / обновлять или нет .cab файл
	

- `[String] PSCabPath`
	Путь к .cab файлу
	* Тип: [System.String][]
	* Псевдонимы: $CabPath
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] PassThru`
	Передавать полученный по конвейеру описатель дальше
	

- `[SwitchParameter] WhatIf`
	* Псевдонимы: wi

- `[SwitchParameter] Confirm`
	* Псевдонимы: cf

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация xml файла справки для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-HelpXML;

##### ПРИМЕЧАНИЯ

Необходимо дополнительное тестирование на PowerShell 3.

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Set-HelpXML)
- [Get-HelpXML][]
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### Get-Readme

Генерирует readme с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Предназначен, в частности, для размещения в репозиториях github. Для сохранения в файл
используйте [Set-Readme][].
Описание может быть сгенерировано функцией [Get-Readme][] для модуля, функции, внешнего сценария.

##### СИНТАКСИС

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

##### ВОЗМОЖНОСТИ

Readme

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Get-Readme` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][].
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Module][].
- [System.Management.Automation.ExternalScriptInfo][].
Описатели сценариев, для которых будет сгенерирован readme.md.
- [System.Management.Automation.CmdletInfo][].
Описатели командлет, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Command][].
- [System.Management.Automation.CommandInfo][].
Описатели функций, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Command][].

##### ВЫХОДНЫЕ ДАННЫЕ

- String.
Содержимое readme.md.

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[ExternalScriptInfo] ExternalScriptInfo`
	Описатель внешнего сценария
	* Тип: [System.Management.Automation.ExternalScriptInfo][]
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[CommandInfo] FunctionInfo`
	Описатель функции
	* Тип: [System.Management.Automation.CommandInfo][]
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

- `[SwitchParameter] ShortDescription`
	Генерировать только краткое описание
	* Псевдонимы: Short

- `[PSModuleInfo[]] ReferencedModules`
	Перечень модулей, упоминания функций которых будут заменены на ссылки
	* Тип: [System.Management.Automation.PSModuleInfo][][]
	* Псевдонимы: RequiredModules
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `@()`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[Array] TranslateRules`
	Правила для обработки readme регулярными выражениями
	* Тип: [System.Array][]
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

1. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в текущем каталоге.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme | Out-File -Path 'readme.md' -Encoding 'UTF8' -Width 1024;

2. Генерация readme для модуля `ITG.Yandex.DnsServer`, при этом все упоминания
функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
`ITG.WinAPI.User32` так же будут заменены перекрёстными ссылками
на readme.md указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Get-Readme)
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

#### Set-Readme

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.
В дополнение к функционалу [Get-Readme][] сохраняет результат в файл, определённый параметром
`-PSPath`.

##### СИНТАКСИС

	Set-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

	Set-Readme [-FunctionInfo] <CommandInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### ВОЗМОЖНОСТИ

Readme

##### РОЛЬ ПОЛЬЗОВАТЕЛЯ

Для выполнения функции `Set-Readme` требуется роль **Everyone** для учётной записи,
от имени которой будет выполнена описываемая функция.

##### ВХОДНЫЕ ДАННЫЕ

- [System.Management.Automation.PSModuleInfo][].
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Module][].
- [System.Management.Automation.ExternalScriptInfo][].
Описатели сценариев, для которых будет сгенерирован readme.md.
- [System.Management.Automation.CmdletInfo][].
Описатели командлет, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Command][].
- [System.Management.Automation.CommandInfo][].
Описатели функций, для которых будет сгенерирован readme.md.
Получены описатели могут быть через [Get-Command][].

##### ПАРАМЕТРЫ

- `[PSModuleInfo] ModuleInfo`
	Описатель модуля
	* Тип: [System.Management.Automation.PSModuleInfo][]
	* Псевдонимы: Module
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[ExternalScriptInfo] ExternalScriptInfo`
	Описатель внешнего сценария
	* Тип: [System.Management.Automation.ExternalScriptInfo][]
	* Требуется? да
	* Позиция? 1
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[CommandInfo] FunctionInfo`
	Описатель функции
	* Тип: [System.Management.Automation.CommandInfo][]
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

- `[String] PSPath`
	Путь для readme файла. По умолчанию - `readme.md` в каталоге модуля
	* Тип: [System.String][]
	* Псевдонимы: Path
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] ShortDescription`
	Генерировать только краткое описание
	* Псевдонимы: Short

- `[PSModuleInfo[]] ReferencedModules`
	Перечень модулей, упоминания функций которых будут заменены на ссылки
	* Тип: [System.Management.Automation.PSModuleInfo][][]
	* Псевдонимы: RequiredModules
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `@()`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[Array] TranslateRules`
	Правила для обработки readme регулярными выражениями
	* Тип: [System.Array][]
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `@()`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[SwitchParameter] PassThru`
	Передавать полученный по конвейеру описатель дальше
	

- `[SwitchParameter] WhatIf`
	* Псевдонимы: wi

- `[SwitchParameter] Confirm`
	* Псевдонимы: cf

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-Readme;

2. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля `ITG.Yandex.DnsServer`, при этом все упоминания
функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
`ITG.WinAPI.User32` так же будут заменены перекрёстными ссылками
на readme.md файлы указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Set-Readme -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.Readme#Set-Readme)
- [Get-Readme][]
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)


[about_Comment_Based_Help]: http://go.microsoft.com/fwlink/?LinkID=144309 "Describes how to write comment-based help topics for functions and scripts."
[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Describes the parameters that can be used with any cmdlet."
[about_Updatable_Help]: http://go.microsoft.com/fwlink/?LinkID=235801 "SHORT DESCRIPTION..."
[Get-AboutModule]: <#get-aboutmodule> "Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с MarkDown разметкой по данным модуля и комментариям к его функциям."
[Get-Command]: <http://go.microsoft.com/fwlink/?linkid=113309> "Gets all commands."
[Get-HelpInfo]: <#get-helpinfo> "Возвращает HelpInfo.xml (как xml) для указанного модуля."
[Get-HelpXML]: <#get-helpxml> "Возващает XML содержимое xml файла справки для переданного модуля."
[Get-Module]: <http://go.microsoft.com/fwlink/?linkid=141552> "Gets the modules that have been imported or that can be imported into the current session."
[Get-Readme]: <#get-readme> "Генерирует readme с MarkDown разметкой по данным модуля и комментариям к его функциям."
[MarkDown]: http://daringfireball.net/projects/markdown/syntax "MarkDown (md) Syntax"
[New-HelpInfo]: <#new-helpinfo> "Генерирует HelpInfo XML для переданного модуля."
[New-HelpXML]: <#new-helpxml> "Генерирует XML справку для переданного модуля, функции, командлеты."
[Set-AboutModule]: <#set-aboutmodule> "Генерирует файл `about_$(ModuleInfo.Name).txt` с MarkDown разметкой по данным модуля и комментариям к его функциям."
[Set-HelpInfo]: <#set-helpinfo> "Генерирует HelpInfo XML для указанного модуля."
[Set-HelpXML]: <#set-helpxml> "Генерирует XML файл справки для переданного модуля, функции, командлеты."
[Set-Readme]: <#set-readme> "Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. Файл предназначен, в частности, для размещения в репозиториях github."
[System.Array]: <http://msdn.microsoft.com/ru-ru/library/system.array.aspx> "Array Class (System)"
[System.Globalization.CultureInfo]: <http://msdn.microsoft.com/ru-ru/library/system.globalization.cultureinfo.aspx> "CultureInfo Class (System.Globalization)"
[System.Management.Automation.CmdletInfo]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.cmdletinfo.aspx> "CmdletInfo Class (System.Management.Automation)"
[System.Management.Automation.CommandInfo]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.commandinfo.aspx> "CommandInfo Class (System.Management.Automation)"
[System.Management.Automation.ExternalScriptInfo]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.externalscriptinfo.aspx> "ExternalScriptInfo Class (System.Management.Automation)"
[System.Management.Automation.PSModuleInfo]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.psmoduleinfo.aspx> "PSModuleInfo Class (System.Management.Automation)"
[System.String]: <http://msdn.microsoft.com/ru-ru/library/system.string.aspx> "String Class (System)"
[System.Uri]: <http://msdn.microsoft.com/ru-ru/library/system.uri.aspx> "Uri Class (System)"
[System.Xml.XmlDocument]: <http://msdn.microsoft.com/ru-ru/library/system.xml.xmldocument.aspx> "XmlDocument Class (System.Xml)"

---------------------------------------

Генератор: [ITG.Readme](https://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

