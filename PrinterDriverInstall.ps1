#!ps # Specify the URL of the HP Universal Print Driver (PCL6) executable
$driverUrl = "https://ftp.hp.com/pub/softlib/software13/printers/UPD/upd-pcl6-x64-7.1.0.25570.exe"

# Specify the local path to save the downloaded driver executable
$downloadPath = "$env:TEMP\upd-pcl6-x64-7.1.0.25570.exe"

# Specify the target directory for extraction
$targetDirectory = "C:\drivers\printer\UniPCL6"

# Download the driver executable
Invoke-WebRequest -Uri $driverUrl -OutFile $downloadPath

# Rename the file from .exe to .zip
$zipFilePath = Join-Path -Path $env:TEMP -ChildPath ('upd-pcl6-x64-7.1.0.25570.zip')
Move-Item -Path $downloadPath -Destination $zipFilePath -Force

# Create the target directory if it doesn't exist
if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $targetDirectory -Force
    Write-Host "Target directory created: $targetDirectory"
}

# Use Expand-Archive to extract the contents to the specified directory
Expand-Archive -Path $zipFilePath -DestinationPath $targetDirectory -Force

Write-Host "Extraction completed successfully to $targetDirectory."
