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

- System.Management.Automation.PSModuleInfo, System.Management.Automation.CmdletInfo,
System.Management.Automation.FunctionInfo, System.Management.Automation.ExternalScriptInfo.
Описатели модулей. Именно для них и будет сгенерирован readme.md.
Получены описатели могут быть через Get-Module, Get-Command.

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

- `OutDefaultFile [<SwitchParameter>]`
        выводить readme в файл readme.md в каталоге модуля

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
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

- `ShortDescription [<SwitchParameter>]`
        Генерировать только краткое описание

        Требуется? false
        Позиция? named
        Значение по умолчанию False
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?false

- `<CommonParameters>`
        Этот командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
        [about_CommonParameters][] (http://go.microsoft.com/fwlink/?LinkID=113216).



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
`ITG.WinAPI.User32`	так же будут заменены перекрёстными ссылками
на readme.md файлы указанных модулей.

		Get-Module 'ITG.Yandex.DnsServer' | Get-Readme -OutDefaultFile -ReferencedModules @( 'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module )

##### См. также

- [Online версия справки](<http://github.com/IT-Service/ITG.Readme#Get-Readme> "Get-Readme")
- [MarkDown][]
- [about_Comment_Based_Help][]
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)


[about_Comment_Based_Help]: http://go.microsoft.com/fwlink/?LinkID=144309 "Describes how to write comment-based help topics for functions and scripts."
[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Describes the parameters that can be used with any cmdlet."
[Get-Readme]: <ITG.Readme#Get-Readme> "Генерирует readme файл с MarkDown разметкой по данным модуля и комментариям к его функциям. Файл предназначен, в частности, для размещения в репозиториях github."
[MarkDown]: http://daringfireball.net/projects/markdown/syntax "MarkDown (md) Syntax"

---------------------------------------

Генератор: [ITG.Readme](http://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

