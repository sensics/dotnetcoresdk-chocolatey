$packageName = 'DotNetCoreSDK'
$fileType = 'exe'
$silentArgs = '/quiet'
$url32 = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x86.exe' # 'https://go.microsoft.com/fwlink/?LinkID=809123'
$url64 = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x64.exe' # 'https://go.microsoft.com/fwlink/?LinkID=809122'
$version = '1.0.0.Preview2'

function Test-RegistryValue {

param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]$Path,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]$Value
)

try {

    if (Test-Path -Path $Path) {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
}

catch {
    return $false
}

}

function CheckDotNetCliInstalled {

    $registryPath = 'HKLM:\SOFTWARE\Wow6432Node\dotnet\Setup\InstalledVersions\x64\sharedfx\Microsoft.NETCore.App'
    if (Test-RegistryValue -Path $registryPath -Value 1.0.0-preview) {
        return $true
    }
}

if (CheckDotNetCliInstalled) {
    Write-Host "Microsoft .Net Core SDK is already installed on your machine."
}
elseif (Get-ProcessorBits(32)) {
	Install-ChocolateyPackage $packageName $fileType $silentArgs '' $url32
}
else {
	Install-ChocolateyPackage $packageName $fileType $silentArgs '' $url64
}
