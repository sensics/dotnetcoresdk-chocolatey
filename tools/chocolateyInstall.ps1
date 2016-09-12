$packageName = 'DotNetCoreSDK'
$fileType = 'exe'
$silentArgs = '/quiet'
$checksumType = 'SHA256'
$url32 = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x86.exe' # 'https://go.microsoft.com/fwlink/?LinkID=809123'
$checksum32 = '5afd32974fa36606b8e1f0d89ff0a0d4db27e7724c8d8e4b7070a10f74f2dc3e'
$url64 = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x64.exe' # 'https://go.microsoft.com/fwlink/?LinkID=809122'
$checksum64 = '967537ba388c4b35cb763c33b8305a9ad598cdc379176bea42a2f0c5a54d80d7'
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
} else {
    Install-ChocolateyPackage -PackageName $packageName -FileType $fileType -SilentArgs $silentArgs \
        -Url $url32       -Checksum $checksum32   -ChecksumType $ChecksumType \
        -Url64Bit $url64  -Checksum64 $Checksum64 -ChecksumType64 $checksumType
}
