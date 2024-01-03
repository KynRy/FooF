#!ps # Specify the target directory for extraction
$targetDirectory = "C:\Drivers\printer\UniPCL6"

# Specify the printer name and driver name
$printerName = "FooF LaserJet M454dw"
$driverName = "HP Universal Printing PCL 6"
$portIP = "10.121.1.16"  # Replace with the desired IP address
$portName = "IP_$portIP"  # Create a unique name for the IP port

# Check if the target directory exists
if (Test-Path -Path $targetDirectory -PathType Container) {
    # List the contents of the target directory
    $driverFiles = Get-ChildItem -Path $targetDirectory -File -Filter *.inf

    # Check if there are INF files in the directory
    if ($driverFiles.Count -gt 0) {
        # Install all drivers in the directory
        foreach ($driverFile in $driverFiles) {
            pnputil.exe /add-driver "$($driverFile.FullName)" /install
            Write-Host "Driver installed successfully from $($driverFile.FullName)."
        }

        # Create a new TCP/IP printer port
        Add-PrinterPort -Name $portName -PrinterHostAddress $portIP -PortNumber 9100

        # Create a new printer using the specified driver and IP port
        Add-Printer -Name $printerName -DriverName $driverName -PortName $portName

        Write-Host "Printer '$printerName' created successfully using driver '$driverName' on IP port '$portIP'."
    } else {
        Write-Host "No INF files found in $($targetDirectory). Please check the extraction."
    }
} else {
    Write-Host "Target directory $($targetDirectory) not found. Please ensure the extraction is successful."
}
