ITG.Readme
==========

Набор функций для PowerShell для генерации readme файла для модулей и функций.

Версия модуля: **1.4.0**

Функции модуля
--------------

[Get-Readme]: <#Get-Readme>

### Readme

#### Обзор Get-Readme

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ShortDescription] <CommonParameters>

Подробнее - [Get-Readme][].

Подробное описание функций модуля
---------------------------------

#### Get-Readme

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

##### Синтаксис

	Get-Readme [-ModuleInfo] <PSModuleInfo> [-OutDefaultFile] [-ShortDescription] <CommonParameters>

	Get-Readme [-ExternalScriptInfo] <ExternalScriptInfo> [-ShortDescription] <CommonParameters>

	Get-Readme [-FunctionInfo] <FunctionInfo> [-ShortDescription] <CommonParameters>

##### Функциональность

Генерирует readme файл с md разметкой по данным модуля и комментариям к его функциям.
Файл предназначен, в частности, для размещения в репозиториях github.

Описание может быть сгенерировано для модуля, функции, внешего сценария.

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

- `ShortDescription [<SwitchParameter>]`

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

##### Связанные ссылки

- [MarkDown (md) Syntax](http://daringfireball.net/projects/markdown/syntax)
- [about_Comment_Based_Help](http://go.microsoft.com/fwlink/?LinkID=144309 "Описание написания разделов справки на основе комментариев для...")
- [Написание справки для командлетов](http://go.microsoft.com/fwlink/?LinkID=123415)

