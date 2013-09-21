ITG.Readme
==========

Набор функций для PowerShell для генерации readme файла для модулей и функций PowerShell.
Файл Readme.md для этого модуля сгенерирован функциями этого же модуля.

Формат генерируемого Readme.MD файла - текстовый файл в кодировке UTF-8 с
разметкой [MarkDown][].

Версия модуля: **2.2.0**

Функции
-------

### AboutModule

#### Обзор [Get-AboutModule][]

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.

	Get-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

Подробнее - [Get-AboutModule][].

#### Обзор [Set-AboutModule][]

Генерирует файл `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.

	Set-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ReferencedModules <PSModuleInfo[]>] [-PassThru] <CommonParameters>

Подробнее - [Set-AboutModule][].

### HelpInfo

#### Обзор [Get-HelpInfo][]

Возвращает HelpInfo.xml (как xml) для указанного модуля.

	Get-HelpInfo [-ModuleInfo] <PSModuleInfo> <CommonParameters>

Подробнее - [Get-HelpInfo][].

#### Обзор [New-HelpInfo][]

Генерирует HelpInfo XML для переданного модуля.

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUriTemplate <ScriptBlock>] [-HelpContentUri <Uri>] <CommonParameters>

Подробнее - [New-HelpInfo][].

#### Обзор [Set-HelpInfo][]

Генерирует HelpInfo XML для указанного модуля.

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] [-UpdateManifest] [-HelpInfoUri <Uri>] [-PassThru] <CommonParameters>

Подробнее - [Set-HelpInfo][].

### HelpXML

#### Обзор [Get-HelpXML][]

Возващает XML содержимое xml файла справки для переданного модуля.

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] <CommonParameters>

Подробнее - [Get-HelpXML][].

#### Обзор [New-HelpXML][]

Генерирует XML справку для переданного модуля, функции, командлеты.

	New-HelpXML [-ModuleInfo] <PSModuleInfo> <CommonParameters>

	New-HelpXML [-FunctionInfo] <FunctionInfo> <CommonParameters>

Подробнее - [New-HelpXML][].

#### Обзор [Set-HelpXML][]

Генерирует XML файл справки для переданного модуля, функции, командлеты.

	Set-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-UpdateModule] [-Cab] [-PSCabPath <String>] [-PassThru] <CommonParameters>

	Set-HelpXML [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-PassThru] <CommonParameters>

Подробнее - [Set-HelpXML][].

### Readme

#### Обзор [Get-Readme][]

Генерирует readme с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

Подробнее - [Get-Readme][].

#### Обзор [Set-Readme][]

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

	Set-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

	Set-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

	Set-Readme [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

Подробнее - [Set-Readme][].

Подробное описание функций модуля
---------------------------------

#### Get-AboutModule

Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям.
         Для сохранения в файл используйте [Set-AboutModule][].

##### Синтаксис

	Get-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ReferencedModules <PSModuleInfo[]>] <CommonParameters>

##### Функциональность

Readme

##### Требуемая роль пользователя

Для выполнения функции Get-AboutModule требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo.
Описатели модулей, для которых будет сгенерирован about.txt.
Получены описатели могут быть через Get-Module.

##### Передаваемые по конвейеру данные

- String.
Содержимое about.txt.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация содержимого about.txt файла для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | Get-AboutModule;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-AboutModule)
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

#### Set-AboutModule

Генерирует файл `about_$(ModuleInfo.Name).txt` с [MarkDown][] разметкой
по данным модуля и комментариям к его функциям в подкаталоге указанной
культуры в каталоге модуля или в соответствии с указанным значением
параметра `Path`.

##### Синтаксис

	Set-AboutModule [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ReferencedModules <PSModuleInfo[]>] [-PassThru] <CommonParameters>

##### Функциональность

Readme

##### Требуемая роль пользователя

Для выполнения функции Set-AboutModule требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo.
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Module.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PSPath <String>`
        Путь для about.txt файла. По умолчанию - в подкаталоге указанной культуры.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PassThru [<SwitchParameter>]`
        Передавать полученный по конвейеру описатель дальше

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация `about_ITG.Yandex.DnsServer.txt` файла для модуля `ITG.Yandex.DnsServer`
в подкаталоге текущей культуры в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-AboutModule;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Set-AboutModule)
- [Get-AboutModule][]
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

#### Get-HelpInfo

Вычисляет наименование и положение HelpInfo.xml файла для указанного модуля
и возвращает его содержимое. Если файл не обнаружен - возвращает пустую
xml "заготовку" HelpInfo.xml, но валидную.

##### Синтаксис

	Get-HelpInfo [-ModuleInfo] <PSModuleInfo> <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции Get-HelpInfo требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет возвращён манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### Передаваемые по конвейеру данные

- System.Xml.XmlDocument
Содержимое XML манифеста (HelpInfo.xml) справки.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Возвращает xml манифест справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpInfo;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-HelpInfo)
- [about_Updatable_Help][]
- [Set-HelpInfo][]
- [New-HelpInfo][]
- [How to Name a HelpInfo XML File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852748.aspx)
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### New-HelpInfo

Генерирует HelpInfo XML для переданного модуля, без записи в файл.
HelpInfo.XML по сути является манифестом для xml справки модуля.

##### Синтаксис

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUriTemplate <ScriptBlock>] [-HelpContentUri <Uri>] <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции New-HelpInfo требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирован манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### Передаваемые по конвейеру данные

- System.Xml.XmlDocument
Содержимое XML манифеста (HelpInfo.xml) справки.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `HelpContentUriTemplate <ScriptBlock>`
        "Заготовка" для `HelpContentURI` - функционал (блок), вычисляющий URI для .cab файлов справки

        Требуется? false
        Позиция? named
        Значение по умолчанию $GitHubHelpContentURI
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `HelpContentUri <Uri>`
        Ссылка для загрузки обновляемой справки. Смотрите [about_Updatable_Help][].
        Значение по умолчанию - url к репозиторию проекта на github.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( & $HelpContentUriTemplate )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация xml манифеста справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | New-HelpInfo;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#New-HelpInfo)
- [about_Updatable_Help][]
- [Set-HelpInfo][]
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Set-HelpInfo

Генерирует HelpInfo XML для переданного модуля, и
вносит изменения (в части текущей культуры) в существующий файл
HelpInfo.xml в каталоге модуля, либо создаёт новый файл.

##### Синтаксис

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentUri <Uri>] [-UpdateManifest] [-HelpInfoUri <Uri>] [-PassThru] <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции Set-HelpInfo требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирован манифест XML справки (HelpInfo.xml).
Получены описатели могут быть через `Get-Module`.

##### Передаваемые по конвейеру данные

- None.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `HelpContentUri <Uri>`
        Ссылка для загрузки обновляемой справки. Смотрите [about_Updatable_Help][].
        Значение по умолчанию - url к репозиторию проекта на github.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `UpdateManifest [<SwitchParameter>]`
        Обновлять или нет манифест модуля. Речь идёт о создании / обновлении параметра
        HelpInfoURI в манифесте, который как раз и должен указывать на HelpInfo.xml файл

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `HelpInfoUri <Uri>`
        Используется только совместно
        с `UpdateManifest`. Значение по умолчанию - url к репозиторию проекта на github.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PassThru [<SwitchParameter>]`
        Передавать полученный по конвейеру описатель дальше

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Создание / модификация HelpInfo.xml файла для модуля `ITG.Yandex.DnsServer` в каталоге модуля.

		Set-HelpInfo -ModuleInfo ( Get-Module 'ITG.Yandex.DnsServer' );

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Set-HelpInfo)
- [about_Updatable_Help][]
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Get-HelpXML

Возващает XML содержимое xml файла справки для переданного модуля.

##### Синтаксис

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции Get-HelpXML требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.

##### Передаваемые по конвейеру данные

- System.Xml.XmlDocument
Содержимое XML справки.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой вернуть данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PSPath <String>`
        Путь для xml файла справки

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Возвращает содержимое xml файла справки для модуля `ITG.Yandex.DnsServer`
в виде XML документа.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpXML;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-HelpXML)
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### New-HelpXML

Генерирует XML справку для переданного модуля, функции, командлеты.

Для генерации / обновления .xml файла справки в каталоге модуля
используйте [Set-HelpXML][].

##### Синтаксис

	New-HelpXML [-ModuleInfo] <PSModuleInfo> <CommonParameters>

	New-HelpXML [-FunctionInfo] <FunctionInfo> <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции New-HelpXML требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.
- System.Management.Automation.FunctionInfo
Описатели функций. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.
- System.Management.Automation.CmdletInfo
Описатели командлет. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.

##### Передаваемые по конвейеру данные

- System.Xml.XmlDocument
Содержимое XML справки.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация xml справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | New-HelpXML;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#New-HelpXML)
- [about_Comment_Based_Help][]
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### Set-HelpXML

Генерирует XML файл справки для переданного модуля, функции, командлеты.

Кроме того, данная
функция создаст XML файл справки в каталоге модуля (точнее - в
подкаталоге культуры, как того и требуют командлеты PowerShell, в
частности - `Get-Help`).

##### Синтаксис

	Set-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-UpdateModule] [-Cab] [-PSCabPath <String>] [-PassThru] <CommonParameters>

	Set-HelpXML [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-PassThru] <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции Set-HelpXML требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Module`.
- System.Management.Automation.FunctionInfo
Описатели функций. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.
- System.Management.Automation.CmdletInfo
Описатели командлет. Именно для них и будет сгенерирована XML справка.
Получены описатели могут быть через `Get-Command`.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PSPath <String>`
        Путь для xml файла справки

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `UpdateModule [<SwitchParameter>]`
        обновлять файл модуля - добавлять в файл модуля в комментарии к функциям модуля
        записи типа `.ExternalHelp ITG.Readme-help.xml`

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `Cab [<SwitchParameter>]`
        генерировать / обновлять или нет .cab файл

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PSCabPath <String>`
        Путь к .cab файлу

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PassThru [<SwitchParameter>]`
        Передавать полученный по конвейеру описатель дальше

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация xml файла справки для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-HelpXML;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Set-HelpXML)
- [about_Updatable_Help][]
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### Get-Readme

Генерирует readme с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Предназначен, в частности, для размещения в репозиториях github. Для сохранения в файл
используйте [Set-Readme][].
Описание может быть сгенерировано функцией [Get-Readme][] для модуля, функции, внешего сценария.

##### Синтаксис

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] <CommonParameters>

##### Функциональность

Readme

##### Требуемая роль пользователя

Для выполнения функции Get-Readme требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo.
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Module.
- System.Management.Automation.ExternalScriptInfo.
Описатели сценариев, для которых будет сгенерирован readme.md.
- System.Management.Automation.CmdletInfo.
Описатели командлет, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.
- System.Management.Automation.FunctionInfo.
Описатели функций, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.

##### Передаваемые по конвейеру данные

- String.
Содержимое readme.md.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `ExternalScriptInfo <ExternalScriptInfo>`
        Описатель внешнего сценария

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ShortDescription [<SwitchParameter>]`
        Генерировать только краткое описание

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `TranslateRules <Array>`
        Правила для обработки readme регулярными выражениями

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в текущем каталоге.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme | Out-File -Path 'readme.md' -Encoding 'UTF8' -Width 1024;

2. Генерация readme для модуля `ITG.Yandex.DnsServer`, при этом все упоминания
функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
`ITG.WinAPI.User32` так же будут заменены перекрёстными ссылками
на readme.md указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-Readme)
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

#### Set-Readme

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.
В дополнение к функционалу [Get-Readme][] сохраняет результат в файл, определённый параметра
`Path`.

##### Синтаксис

	Set-Readme [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-PSPath <String>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

	Set-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

	Set-Readme [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] [-ShortDescription] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-PassThru] <CommonParameters>

##### Функциональность

Readme

##### Требуемая роль пользователя

Для выполнения функции Set-Readme требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

- System.Management.Automation.PSModuleInfo.
Описатели модулей, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Module.
- System.Management.Automation.ExternalScriptInfo.
Описатели сценариев, для которых будет сгенерирован readme.md.
- System.Management.Automation.CmdletInfo.
Описатели командлет, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.
- System.Management.Automation.FunctionInfo.
Описатели функций, для которых будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `ExternalScriptInfo <ExternalScriptInfo>`
        Описатель внешнего сценария

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?false

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные.

        Требуется? false
        Позиция? named
        Значение по умолчанию ( Get-Culture )
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PSPath <String>`
        Путь для readme файла. По умолчанию - `readme.md` в каталоге модуля

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ShortDescription [<SwitchParameter>]`
        Генерировать только краткое описание

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `TranslateRules <Array>`
        Правила для обработки readme регулярными выражениями

        Требуется? false
        Позиция? named
        Значение по умолчанию @()
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `PassThru [<SwitchParameter>]`
        Передавать полученный по конвейеру описатель дальше

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][].



##### Примеры использования

1. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Set-Readme;

2. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля `ITG.Yandex.DnsServer`, при этом все упоминания
функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
`ITG.WinAPI.User32` так же будут заменены перекрёстными ссылками
на readme.md файлы указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Set-Readme -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Set-Readme)
- [Get-Readme][]
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)


[about_Comment_Based_Help]: http://go.microsoft.com/fwlink/?LinkID=144309 "Describes how to write comment-based help topics for functions and scripts."
[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Describes the parameters that can be used with any cmdlet."
[about_Updatable_Help]: http://go.microsoft.com/fwlink/?LinkID=235801 "SHORT DESCRIPTION..."
[Get-AboutModule]: <#get-aboutmodule> "Генерирует содержимое файла `about_$(ModuleInfo.Name).txt` с MarkDown разметкой по данным модуля и комментариям к его функциям."
[Get-HelpInfo]: <#get-helpinfo> "Возвращает HelpInfo.xml (как xml) для указанного модуля."
[Get-HelpXML]: <#get-helpxml> "Возващает XML содержимое xml файла справки для переданного модуля."
[Get-Readme]: <#get-readme> "Генерирует readme с MarkDown разметкой по данным модуля и комментариям к его функциям."
[MarkDown]: http://daringfireball.net/projects/markdown/syntax "MarkDown (md) Syntax"
[New-HelpInfo]: <#new-helpinfo> "Генерирует HelpInfo XML для переданного модуля."
[New-HelpXML]: <#new-helpxml> "Генерирует XML справку для переданного модуля, функции, командлеты."
[Set-AboutModule]: <#set-aboutmodule> "Генерирует файл `about_$(ModuleInfo.Name).txt` с MarkDown разметкой по данным модуля и комментариям к его функциям."
[Set-HelpInfo]: <#set-helpinfo> "Генерирует HelpInfo XML для указанного модуля."
[Set-HelpXML]: <#set-helpxml> "Генерирует XML файл справки для переданного модуля, функции, командлеты."
[Set-Readme]: <#set-readme> "Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. Файл предназначен, в частности, для размещения в репозиториях github."

---------------------------------------

Генератор: [ITG.Readme](http://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

