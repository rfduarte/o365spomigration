Set-ExecutionPolicy -ExecutionPolicy Unrestricted
$o365Accountadmin = Read-Host 'Entre com a conta administrativa do Office365'
$creds = (Get-Credential $o365Accountadmin)
$sourceFiles = Read-Host -Prompt 'Digite o caminho dos arquivos'
$sourcePackage = Read-Host -Prompt 'Digite o caminho de origem do pacote'
$targetPackage = Read-Host -Prompt 'Digite o caminho de destino do pacote'
$targetWeb = Read-Host -Prompt 'Digite a URL do site Sharepoint'
$targetDocLib = Read-Host -Prompt 'Digite o nome da biblioteca do Sharepoint'
$azureAccountName = Read-Host -Prompt 'Digite o nome da conta de armazenamento Blob AZURE'
$azureAccountKey = Read-Host -Prompt 'Digite a chave da conta de armazenamento Blob AZURE'

New-SPOMigrationPackage -SourceFilesPath $sourceFiles -OutputPackagePath $sourcePackage
ConvertTo-SPOMigrationTargetedPackage -SourceFilesPath $sourceFiles -SourcePackagePath $sourcePackage -OutputPackagePath $targetPackage -TargetWebUrl $targetWeb -TargetDocumentLibraryPath $targetDocLib -Credentials $creds
$al = Set-SPOMigrationPackageAzureSource -SourceFilesPath $sourceFiles -SourcePackagePath $targetPackage -AccountName $azureAccountName -AccountKey $azureAccountKey
$al|fl
Submit-SPOMigrationJob -TargetWebUrl $targetWeb -MigrationPackageAzureLocations $al -Credentials $creds
$azureSource = Set-SPOMigrationPackageAzureSource -SourceFilesPath $sourceFiles -SourcePackagePath $sourcePackage -AccountName $azureAccountName -AccountKey $azureAccountKey
Submit-SPOMigrationJob -TargetWebUrl $targetWeb -MigrationPackageAzureLocations $azureSource -Credentials $creds