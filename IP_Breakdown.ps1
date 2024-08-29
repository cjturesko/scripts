# Define the URL of the file to download
$url = "https://raw.githubusercontent.com/X4BNet/lists_vpn/main/output/datacenter/ipv4.txt"

# Define the path where you want to save the downloaded file
$downloadedFilePath = ".\Temp\ipv4.txt"

$inputFilePath = $downloadedFilePath

# Download the file using Invoke-WebRequest
Invoke-WebRequest -Uri $url -OutFile $downloadedFilePath

# Define the directory where you want to save the output files
$outputDirectory = ".\Temp\"

# Define the number of lines per output file
$linesPerFile = 2000  # Change this value as needed

# Read the input file
$content = Get-Content -Path $inputFilePath

# Calculate the number of output files needed
$numFiles = [Math]::Ceiling($content.Count / $linesPerFile)

# Loop through each section of the input file and write to separate output files
for ($i = 0; $i -lt $numFiles; $i++) {
    $startLine = $i * $linesPerFile
    $endLine = [Math]::Min(($i + 1) * $linesPerFile, $content.Count)
    $outputFileName = "Commercial VPN IP Range $($i + 1) of $numFiles.txt"
    $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName
    $content[$startLine..($endLine - 1)] | Out-File -FilePath $outputFilePath
}
