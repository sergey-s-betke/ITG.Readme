# culture="ru-RU"

ConvertFrom-StringData @'
ModuleVersion = Версия модуля
## CmdletsSupportedCaps = Функции
Variables = Переменные и константы
## AliasesSection = ПСЕВДОНИМЫ
## DetailedDescription = Подробное описание
## ShortDescription = Краткое описание {0}
## Syntax = Синтаксис
Component = КОМПОНЕНТ
## Capabilities = Функциональность
Role = РОЛЬ ПОЛЬЗОВАТЕЛЯ
RoleDetails = Для выполнения функции {1} требуется роль {0} для учётной записи,\nот имени которой будет выполнена описываемая функция.
## InputType = Принимаемые данные по конвейеру
## ReturnType = Передаваемые по конвейеру данные
## Parameters = Параметры
## TypeColon = Тип:
AliasesColon = Псевдонимы:
## Examples = Примеры использования
## Example = Пример {0}
## Notes = Примечания
## RelatedLinks = См. также
OnlineHelp = Интернет версия
GeneratorAbout= Генератор: [{0}]({1} "Модуль PowerShell для генерации readme для модулей PowerShell").
GeneratorXmlAbout = Генератор: {0} ({1}).
FalseShort = нет
TrueShort = да

WarningUnknownAboutTerm = Обнаружен термин about_*, для которого не найдено определение. \nПроверьте правильность написания термина:
WarningUnknownModuleReadmeURL = В качестве зависимости при генерации справки использован модуль {0},\nв манифесте которого в PrivateData не определён ReadmeURL (url документа с описаниями функций модуля).\nРекомендуем указать url в манифесте модуля следующим образом (пример):
WarningLinkError = Обнаружена ошибка при оформлении раздела .Link в справке к функции {0}.\nЕсли содержание указанного раздела начинается с URL, то оно трактуется как ссылка на online\nверсию справки. И не может содержать ничего, кроме URL.\n\nРаздел с ошибочным содержанием:
WarningCommandHelpUriNotDefined = Для команды {0} не указан аттрибут HelpUri.
WarningCommandHelpUriAndLinkNotDefined = Для команды {0} не указан аттрибут HelpUri, также отсутствуют ссылки на online справку и в разделах .Link.

ErrorModuleManifestPathMessage = Не обнаружен манифест {0} модуля. XML справка может быть получена только при наличии манифеста.
ErrorModuleManifestPathActivity = Загрузка манифеста модуля
ErrorModuleManifestPathReason = Не обнаружен манифест модуля.
ErrorModuleManifestPathRecommendedAction = Создайте .psd1 манифест к модулю и разместите его в каталоге модуля.

ErrorMakeCabMessage = Возникла ошибка {0} при выполнении makecab.exe.

VerboseWriteReadme = Создание readme файла "{1}" для модуля {0}.
VerboseWriteAbout = Создание файла about.txt "{1}" для модуля {0}.
VerboseWriteHelpXML = Создание файлов _help.xml "{1}" и .cab "{2}" для модуля {0}.
VerboseWriteHelpInfo = Создание файлов _HelpInfo.xml "{1}" для модуля {0}.
'@
