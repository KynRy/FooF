# Specify the URL of the HP Universal Print Driver (PCL6) executable
$driverUrl = "https://ftp.hp.com/pub/softlib/software13/printers/UPD/upd-pcl6-x64-7.2.0.25780.exe"

# Specify the local path to save the downloaded driver executable
$downloadPath = "$env:TEMP\upd-pcl6-x64.exe"

# Specify the target directory for extraction
$targetDirectory = "C:\drivers\printer\UniPCL6"

# Download the driver executable
Write-Host "Downloading driver from $driverUrl"
Invoke-WebRequest -Uri $driverUrl -OutFile $downloadPath

# Check if the file exists after download
if (-not (Test-Path -Path $downloadPath)) {
    Write-Warning "The driver executable was not downloaded successfully."
    exit
}

# Rename the file from .exe to .zip
$zipFilePath = Join-Path -Path $env:TEMP -ChildPath ('upd-pcl6-x64.zip')
Move-Item -Path $downloadPath -Destination $zipFilePath -Force

# Create the target directory if it doesn't exist
if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $targetDirectory -Force
    Write-Host "Target directory created: $targetDirectory"
}

# Use Expand-Archive to extract the contents to the specified directory
Write-Host "Extracting driver files to $targetDirectory"
Expand-Archive -Path $zipFilePath -DestinationPath $targetDirectory -Force

Write-Host "Extraction completed successfully to $targetDirectory."

# Check the target directory for drivers and install them
$driverFiles = Get-ChildItem -Path $targetDirectory -Filter "*.inf" -Recurse

if ($driverFiles.Count -eq 0) {
    Write-Warning "No driver files found in the target directory."
    exit
}

foreach ($driverFile in $driverFiles) {
    Write-Host "Installing driver: $($driverFile.FullName)"
    try {
        $result = Start-Process -FilePath "pnputil" -ArgumentList "/add-driver `"$($driverFile.FullName)`" /install" -NoNewWindow -Wait -PassThru
        if ($result.ExitCode -ne 0) {
            Write-Error "Failed to install driver: $($driverFile.FullName)"
        } else {
            Write-Host "Driver installed successfully: $($driverFile.FullName)"
        }
    } catch {
        Write-Error "An error occurred while installing driver: $($driverFile.FullName). Error: $_"
    }
}

Write-Host "All drivers installed successfully."
