# Customize EXSi ISO With required Network Drivers

If you want to use `GitHub Actions` yourself, your need add own `TOKEN` to `Secrets`

## check the hardware of which network driver you need

```bash
[jason@bo ~]$ lspci | grep -i Ethernet
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
```

## Find the suitable driver for your device

> ⚠️ WarningMake Sure **Exsi version which compatible with the driver**

- Third-party Supported driver list:

  https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages

- VMware Community Driver

  https://flings.vmware.com/community-networking-driver-for-esxi

  https://flings.vmware.com/community-networking-driver-for-esxi#requirements

## Customize your driver into ISO

  ```powershell
# use online driver and online base image
.\ESXi-Customizer-PS.ps1 -nsc -v60 -vft -load sata-xahci,net55-r8168 -ipname <ISO_File_name>

# Export Main base image
Add-EsxSoftwareDepot https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
Get-EsxImageProfile |ft Name |findstr "ESXi-8.0.0"
Export-ESXImageProfile -ImageProfile "ESXi-8.0.0-20513097-standard" -ExportToBundle -filepath ESXi-8.0.0-20513097-standard.zip

# Download Driver to build work dir
$URL = 'https://download3.vmware.com/software/vmw-tools/community-network-driver/Net-Community-Driver_1.2.7.0-1vmw.700.1.0.15843807_19480755.zip'
$DEST = '.\Net-Community-Driver.zip'
Invoke-RestMethod -Uri $URL -OutFile $DEST -Verbose
Expand-Archive -Path $DEST -DestinationPath .\driver
dir .\driver\vib20\net-community

# use online base image
.\ESXi-Customizer-PS.ps1 -nsc -vft -v80 -pkgDir .\driver\vib20\net-community -ipname ESXi-8.0.0-net-community
# use offline base image
.\ESXi-Customizer-PS.ps1 -izip .\ESXi-8.0.0-20513097-standard.zip -nsc -v80 -pkgDir .\driver\vib20\net-community -ipname ESXi-8.0.0-net-community
  ```

> More Information

- [Currently_available_ESXi_packages](https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages)
- https://github.com/VFrontDe-Org/ESXi-Customizer-PS
- https://oss.msft.vip/2023/02/10/custom-exsi-iso-with-Additional-driver

> Small tips

Github Actions to Install VMware.Powercli, offline install will so much faster then we use `Install-Module -Name VMware.PowerCLI -SkipPublisherCheck -Scope CurrentUser -Force`

Offline install VMware.PowerCLI( `top 5mins` )

![image](https://user-images.githubusercontent.com/88020021/219365299-ceddb02a-113e-4123-bf59-d43f2ea19c00.png)

```powershell
# Download VMware.PowerCli
$source = 'https://vdc-repo.vmware.com/vmwb-repository/dcr-public/02830330-d306-4111-9360-be16afb1d284/c7b98bc2-fcce-44f0-8700-efed2b6275aa/VMware-PowerCLI-13.0.0-20829139.zip'
$destination = '.\VMware-PowerCLI-13.0.0-20829139.zip'
Invoke-RestMethod -Uri $source -OutFile $destination -Verbose

# Define Powershell Moudle Path
$modulepath = 'C:\Program Files\WindowsPowerShell\Modules'

# Unzip PowerCli Module defined Moudle Path
Expand-Archive -LiteralPath $destination -DestinationPath $modulepath

# Load the new Moudle and Verify
Get-ChildItem $modulepath\* -Recurse | Unblock-File

# Verify
Get-Module -Name VMware.PowerCLI* -ListAvailable 
```

When I use `Install-Moudle` in Github Actions, It takes 1H, it surprise me !!!

![image](https://user-images.githubusercontent.com/88020021/219365864-bfee201d-0cb0-4b70-a0ea-3c9aa01bb871.png)


```powershell
Install-Module -Name VMware.PowerCLI -SkipPublisherCheck -Scope CurrentUser -Force
```
