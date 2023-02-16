 # Download VMware.PowerCli
$source = 'https://vdc-repo.vmware.com/vmwb-repository/dcr-public/02830330-d306-4111-9360-be16afb1d284/c7b98bc2-fcce-44f0-8700-efed2b6275aa/VMware-PowerCLI-13.0.0-20829139.zip'
$destination = '.\VMware-PowerCLI-13.0.0-20829139.zip'
Invoke-RestMethod -Uri $source -OutFile $destination

# Define Powershell Moudle Path
$modulepath = 'C:\Program Files\WindowsPowerShell\Modules'

# Unzip PowerCli Module to System Moudle Path
Expand-Archive -LiteralPath $destination -DestinationPath $modulepath

# Load the new Moudle and Verify
Get-ChildItem $modulepath\* -Recurse | Unblock-File
Get-Module -Name VMware.PowerCLI* -ListAvailable 
