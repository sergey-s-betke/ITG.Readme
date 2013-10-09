# culture="en-U"

ConvertFrom-StringData @'
ModuleVersion = Module version
## CmdletsSupportedCaps = Functions
Variables = Variables and constants
## AliasesSection = ALIASES
## DetailedDescription = Detailed description
## ShortDescription = Overview {0}
## Syntax = Syntax
Component = COMPONENT
## Capabilities = Functionality
Role = USER ROLE
RoleDetails = To perform the functions {1} is required role {0} to account on behalf\nof which will be executed the function.
## InputType = Input types
## ReturnType = Return values
## Parameters = Parameters
## TypeColon = Type:
AliasesColon = Aliases
## Examples = Examples
## Example = Example
## Notes = Notes
## RelatedLinks = Related links
OnlineHelp = Online help
GeneratorAbout = Generator: [{0}]({1} "PowerShell module for readme.md creating").
GeneratorXmlAbout = Generator: {0} ({1}).

WarningUnknownAboutTerm = Discovered term about_ *, for which the definition is not found.\nPlease check the spelling of the term:
WarningUnknownModuleReadmeURL = Required module {0} hasn't specified ReadmeURL in PrivateData.\n Please, specify ReadmeURL in the module manifest, by example:
WarningLinkError = Error detected at .Link comment section for fuction {0}.\nIf the contents of the specified section begins with a URL, then it is interpreted as a reference to online help,\n and it can't contain something with the URL.\nThe partition with erroneous content:
WarningCommandHelpUriNotDefined = For command {0} doesn't specified HelpUri.
WarningCommandHelpUriAndLinkNotDefined = For command {0} doesn't specified HelpUri, and cann't detect .Link comment section with correct online help uri.

ErrorModuleManifestPathMessage = Module {0} manifest not found. XMLHelp can't be generated without module manifest.
ErrorModuleManifestPathActivity = Module manifest loading
ErrorModuleManifestPathReason = Module manifest not found.
ErrorModuleManifestPathRecommendedAction = Create .psd1 module manifest file.

ErrorMakeCabMessage = Makecab.exe runtime error {0}.

VerboseWriteReadme = Creating readme file "{1}" for module {0}.
VerboseWriteAbout = Creating about.txt file "{1}" for module {0}.
VerboseWriteHelpXML = Creating _help.xml file "{1}" and .cab file "{2}" for module {0}.
VerboseWriteHelpInfo = Creating _HelpInfo.xml file "{1}" for module {0}.
'@
