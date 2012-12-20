ITG.Readme
==========

Набор функций для PowerShell для генерации readme файла для модулей и функций.
Файл Readme.md для этого модуля сгенерирован функциями этого же модуля.
Весь функционал модуля предоставлен командлетом [Get-Readme][].

Версия модуля: **1.5.0**

Функции модуля
--------------

[Get-Readme]: <#Get-Readme>

### Readme

#### Обзор [Get-Readme][]

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям. 
Файл предназначен, в частности, для размещения в репозиториях github.

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

Подробнее - [Get-Readme][].

Подробное описание функций модуля
---------------------------------

#### Get-Readme

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

##### Синтаксис

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ReferencedModules <PSModuleInfo[]>] [-TranslateRules <Hashtable[]>] [-ShortDescription] <CommonParameters>

##### Функциональность

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

Описание может быть сгенерировано функцией [Get-Readme][] для модуля, функции, внешего сценария.

##### Требуемая роль пользователя

Для выполнения функции Get-Readme требуется роль Everyone для учётной записи,
от имени которой будет выполнена описываемая функция.

##### Принимаемые данные по конвейеру

System.Management.Automation.PSModuleInfo
Описатели модулей. Именно для них и будет сгенерирован readme.md.
Получены описатели могут быть через Get-Module.

System.Management.Automation.CmdletInfo
Через конвейер функция принимает описатели командлет. Именно для них и будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.

System.Management.Automation.FunctionInfo
Через конвейер функция принимает описатели функций. Именно для них и будет сгенерирован readme.md.
Получены описатели могут быть через Get-Command.

System.Management.Automation.ExternalScriptInfo
Через конвейер функция принимает описатели внешних сценариев. Именно для них и будет сгенерирован readme.md.

##### Передаваемые по конвейеру данные

String
Содержимое readme.md.

##### Параметры

- `ModuleInfo <PSModuleInfo>`
        Описатель модуля

        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `OutDefaultFile [<SwitchParameter>]`
        выводить readme в файл readme.md в каталоге модуля

        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `ExternalScriptInfo <ExternalScriptInfo>`
        Описатель внешнего сценария

        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `FunctionInfo <FunctionInfo>`
        Описатель внешнего сценария

        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByValue)
        Принимать подстановочные знаки?

- `ReferencedModules <PSModuleInfo[]>`
        Перечень модулей, упоминания функций которых будут заменены на ссылки

        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `TranslateRules <Hashtable[]>`
        Правила для обработки readme регулярными выражениями. Задавать явно не требуется,
        используется параметр в реккурсивных вызовах

        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `ShortDescription [<SwitchParameter>]`
        Генерировать только краткое описание

        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?

- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216 "Описание параметров, которые могут использоваться с любым командлетом....")".



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

##### Связанные ссылки

- [MarkDown (md) Syntax](http://daringfireball.net/projects/markdown/syntax)
- [about_Comment_Based_Help](http://go.microsoft.com/fwlink/?LinkID=144309 "Описание написания разделов справки на основе комментариев для...")
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

