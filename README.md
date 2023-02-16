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

- https://github.com/VFrontDe-Org/ESXi-Customizer-PS.git
- [Currently_available_ESXi_packages](https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages)
- [https://oss.msft.vip/2023/02/10/custom-exsi-iso-with-Additional-driver/](https://oss.msft.vip/2023/02/10/custom-exsi-iso-with-Additional-driver/)

