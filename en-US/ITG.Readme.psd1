# culture="en-U"

ConvertFrom-StringData @'
ModuleVersion = Module version
Funtions = Functions
Details = Details - {0}.
FunctionsDescriptionFull = Detailed description of the module's functions
FunctionDescriptionFull = {0}
Overview = Overview {0}
Syntax = Syntax
Component = Component
Functionality = Functionality
Role = The required user role
RoleDetails = To perform the functions {1} is required role {0} to account on behalf\nof which will be executed the function.
InputTypes = Input types
ReturnValues = Return values
Parameters = Parameters
Examples = Examples
Example = Example {0}.
RelatedLinks = Related links
OnlineHelp = Online help
GeneratorAbout = Generator: [{0}]({1} "PowerShell module for readme.md creating").
GeneratorXmlAbout = Generator: {0} ({1}).

WarningUnknownAboutTerm = Discovered term about_ *, for which the definition is not found.\nPlease check the spelling of the term:
WarningUnknownModuleReadmeURL = Required module {0} hasn't specified ReadmeURL in PrivateData.\n Please, specify ReadmeURL in the module manifest, by example:
WarningLinkError = Error detected at .Link comment section for fuction {0}.\nIf the contents of the specified section begins with a URL, then it is interpreted as a reference to online help,\n and it can't contain something with the URL.\nThe partition with erroneous content:

ErrorModuleManifestPathMessage = Module {0} manifest not found. XMLHelp can't be generated without module manifest.
ErrorModuleManifestPathActivity = Module manifest loading
ErrorModuleManifestPathReason = Module manifest not found.
ErrorModuleManifestPathRecommendedAction = Create .psd1 module manifest file.

ErrorMakeCabMessage = Makecab.exe runtime error {0}.
'@
