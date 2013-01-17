ITG.Readme
==========

Набор функций для PowerShell для генерации readme файла для модулей и функций.
Файл Readme.md для этого модуля сгенерирован функциями этого же модуля.
Весь функционал модуля предоставлен командлетом [Get-Readme][].

Формат генерируемого Readme.MD файла - текстовый файл в кодировке UTF-8 с
разметкой [MarkDown][].

Версия модуля: **1.6.3**

Функции модуля
--------------

### HelpInfo

#### Обзор [Get-HelpInfo][]

Возвращает HelpInfo.xml (как xml) для указанного модуля.

	Get-HelpInfo [-ModuleInfo] <PSModuleInfo> <CommonParameters>

Подробнее - [Get-HelpInfo][].

#### Обзор [New-HelpInfo][]

Генерирует HelpInfo XML для переданного модуля.

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentURITemplate <ScriptBlock>] <CommonParameters>

Подробнее - [New-HelpInfo][].

#### Обзор [Set-HelpInfo][]

Генерирует HelpInfo XML для указанного модуля.

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentURITemplate <ScriptBlock>] [-UpdateManifest] [-HelpInfoUriTemplate <ScriptBlock>] [-HelpInfoUri <Uri>] <CommonParameters>

Подробнее - [Set-HelpInfo][].

### HelpXML

#### Обзор [Get-HelpXML][]

Генерирует XML справку для переданного модуля, функции, командлеты.

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-OutDefaultFile] [-Cab] [-CabPathTemplate <ScriptBlock>] [-CabPath <FileInfo>] <CommonParameters>

	Get-HelpXML [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] <CommonParameters>

Подробнее - [Get-HelpXML][].

### Readme

#### Обзор [Get-Readme][]

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

Подробнее - [Get-Readme][].

Подробное описание функций модуля
---------------------------------

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
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        [`get-help about_CommonParameters`][about_CommonParameters].



##### Примеры использования

1. Возвращает xml манифест справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpInfo;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-HelpInfo)
- about_Updatable_Help
- [Set-HelpInfo][]
- [New-HelpInfo][]
- [How to Name a HelpInfo XML File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852748.aspx)
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### New-HelpInfo

Генерирует HelpInfo XML для переданного модуля, без записи в файл.
HelpInfo.XML по сути является манифестом для xml справки модуля.

##### Синтаксис

	New-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentURITemplate <ScriptBlock>] <CommonParameters>

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
        Принимать подстановочные знаки?

- `HelpContentURITemplate <ScriptBlock>`
        "Заготовка" для `HelpContentURI` - функционал (блок), вычисляющий URI для .cab файлов справки

        По умолчанию используется URI для github вида

            { "<http://raw.github.com/IT-Service/$>( $ModuleInfo.Name )/$( $ModuleInfo.Version )/help.cab" }

        Вероятнее всего, Вам потребуется переопределять "генератор" данного URI.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        [`get-help about_CommonParameters`][about_CommonParameters].



##### Примеры использования

1. Генерация xml манифеста справки для модуля `ITG.Yandex.DnsServer`.

		Get-Module 'ITG.Yandex.DnsServer' | New-HelpInfo;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#New-HelpInfo)
- about_Updatable_Help
- [Set-HelpInfo][]
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Set-HelpInfo

Генерирует HelpInfo XML для переданного модуля, и
вносит изменения (в части текущей культуры) в существующий файл
HelpInfo.xml в каталоге модуля, либо создаёт новый файл.

##### Синтаксис

	Set-HelpInfo [-ModuleInfo] <PSModuleInfo> [-HelpContentURITemplate <ScriptBlock>] [-UpdateManifest] [-HelpInfoUriTemplate <ScriptBlock>] [-HelpInfoUri <Uri>] <CommonParameters>

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
        Принимать подстановочные знаки?

- `HelpContentURITemplate <ScriptBlock>`
        "Заготовка" для `HelpContentURI` - функционал (блок), вычисляющий URI для .cab файлов справки

        По умолчанию используется URI для github вида

            { "<http://raw.github.com/IT-Service/$>( $ModuleInfo.Name )/$( $ModuleInfo.Version )/help.cab" }

        Вероятнее всего, Вам потребуется переопределять "генератор" данного URI.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `UpdateManifest [<SwitchParameter>]`
        Обновлять или нет манифест модуля. Речь идёт о создании / обновлении параметра
        HelpInfoURI в манифесте, который как раз и должен указывать на HelpInfo.xml файл

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `HelpInfoUriTemplate <ScriptBlock>`
        Функционал (`[ScriptBlock]`), вычисляющий `HelpInfoUri`. Используется только совместно
        с `UpdateManifest`. Значение по умолчанию генерирует url к репозиторию проекта на github.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `HelpInfoUri <Uri>`
        Используется только совместно
        с `UpdateManifest`. Значение по умолчанию - url к репозиторию проекта на github.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        [`get-help about_CommonParameters`][about_CommonParameters].



##### Примеры использования

1. Создание / модификация HelpInfo.xml файла для модуля `ITG.Yandex.DnsServer` в каталоге модуля.

		Set-HelpInfo -ModuleInfo ( Get-Module 'ITG.Yandex.DnsServer' );

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Set-HelpInfo)
- about_Updatable_Help
- [HelpInfo XML Sample File](http://msdn.microsoft.com/en-us/library/windows/desktop/hh852750.aspx)

#### Get-HelpXML

Генерирует XML справку для переданного модуля, функции, командлеты.

Кроме того, для модуля при указании ключа `-OutDefaultFile` данная
функция создаст XML файл справки в каталоге модуля (точнее - в
подкаталоге культуры, как того и требуют командлеты PowerShell, в
частности - `Get-Help`).

##### Синтаксис

	Get-HelpXML [-ModuleInfo] <PSModuleInfo> [-UICulture <CultureInfo>] [-OutDefaultFile] [-Cab] [-CabPathTemplate <ScriptBlock>] [-CabPath <FileInfo>] <CommonParameters>

	Get-HelpXML [-FunctionInfo] <FunctionInfo> [-UICulture <CultureInfo>] <CommonParameters>

##### Требуемая роль пользователя

Для выполнения функции Get-HelpXML требуется роль Everyone для учётной записи,
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
        Принимать подстановочные знаки?

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `UICulture <CultureInfo>`
        культура, для которой генерировать данные, на данный момент параметр задавать не следует.

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `OutDefaultFile [<SwitchParameter>]`
        выводить help в файл `<ModuleName>-Help.xml` в каталоге модуля

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `Cab [<SwitchParameter>]`
        генерировать / обновлять или нет .cab файл

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `CabPathTemplate <ScriptBlock>`
        функционал (`[ScriptBlock]`), вычисляющий полный путь к .cab файлу

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `CabPath <FileInfo>`
        Путь к .cab файлу

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        [`get-help about_CommonParameters`][about_CommonParameters].



##### Примеры использования

1. Генерация xml файла справки для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Get-HelpXML -OutDefaultFile;

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-HelpXML)
- [about_Comment_Based_Help][]
- about_Updatable_Help
- [Creating the Cmdlet Help File](http://msdn.microsoft.com/en-us/library/bb525433.aspx)

#### Get-Readme

Генерирует readme файл с [MarkDown][] разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.
Описание может быть сгенерировано функцией [Get-Readme][] для модуля, функции, внешего сценария.

##### Синтаксис

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Array>] [-ShortDescription] <CommonParameters>

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
        Принимать подстановочные знаки?

- `OutDefaultFile [<SwitchParameter>]`
        выводить readme в файл readme.md в каталоге модуля

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `ExternalScriptInfo <ExternalScriptInfo>`
        Описатель внешнего сценария

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `FunctionInfo <FunctionInfo>`
        Описатель функции

        Требуется? true
        Позиция? 1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `TranslateRules <Array>`
        Правила для обработки readme регулярными выражениями

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `ShortDescription [<SwitchParameter>]`
        Генерировать только краткое описание

        Требуется? false
        Позиция? named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        [`get-help about_CommonParameters`][about_CommonParameters].



##### Примеры использования

1. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в текущем каталоге.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme | Out-File -Path 'readme.md' -Encoding 'UTF8' -Width 1024;

2. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -OutDefaultFile;

3. Генерация readme.md файла для модуля `ITG.Yandex.DnsServer`
в каталоге модуля `ITG.Yandex.DnsServer`, при этом все упоминания
функций модулей `ITG.Yandex`, `ITG.Utils`, `ITG.WinAPI.UrlMon`,
`ITG.WinAPI.User32` так же будут заменены перекрёстными ссылками
на readme.md файлы указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -OutDefaultFile -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### См. также

- [Online версия справки](http://github.com/IT-Service/ITG.Readme#Get-Readme)
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)


[about_Comment_Based_Help]: http://go.microsoft.com/fwlink/?LinkID=144309 "Описание написания разделов справки на основе комментариев для..."
[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Описание параметров, которые могут использоваться с любым командлетом."
[Get-HelpInfo]: <ITG.Readme#Get-HelpInfo> "Возвращает HelpInfo.xml (как xml) для указанного модуля."
[Get-HelpXML]: <ITG.Readme#Get-HelpXML> "Генерирует XML справку для переданного модуля, функции, командлеты."
[Get-Readme]: <ITG.Readme#Get-Readme> "Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. Файл предназначен, в частности, для размещения в репозиториях github."
[MarkDown]: http://daringfireball.net/projects/markdown/syntax "MarkDown (md) Syntax"
[New-HelpInfo]: <ITG.Readme#New-HelpInfo> "Генерирует HelpInfo XML для переданного модуля."
[Set-HelpInfo]: <ITG.Readme#Set-HelpInfo> "Генерирует HelpInfo XML для указанного модуля."

---------------------------------------

Генератор: [ITG.Readme](http://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

