<#
Если psake включён в %Path%, этот файл в принципе не требуется, достаточно запустить psake build.psake.ps1, результат будет тот же.
#>

Import-Module psake;

Invoke-Psake `
	-buildFile (
		Join-Path `
			-Path (
				Split-Path `
					-Path $MyInvocation.MyCommand.Path `
					-Parent `
			) `
			-ChildPath 'build.psake.ps1' `
	) `
;

if ( $psake.build_success -eq $false ) { exit 1 } else { exit 0 };
