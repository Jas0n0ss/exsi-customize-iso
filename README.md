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

### Customize with third-party on-line driver and on-line Base image

```yaml
- name:  Generate EXSi6.0 with Driver sata-xahci,net55-r8168
  shell: powershell
  run: |
    cd $WORK_DIR
    .\ESXi-Customizer-PS.ps1 -nsc -v60 -vft -load sata-xahci,net55-r8168 -ipname ${{ github.event.inputs.tag }} -outDir ..\ -log ..\buildlog.txt
```

### Customize with downloaded offline driver and offline base image

  #### Download base image

  ```powershell
Add-EsxSoftwareDepot https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
Get-EsxImageProfile |ft Name |findstr "ESXi-8.0.0"
Export-ESXImageProfile -ImageProfile "ESXi-8.0.0-20513097-standard" -ExportToBundle -filepath ESXi-8.0.0-20513097-standard.zip
  ```

  #### Download Driver to build work dir

  ```powershell
$client = new-object System.Net.WebClient
$client.DownloadFile('https://download3.vmware.com/software/vmw-tools/community-network-driver/Net-Community-Driver_1.2.7.0-1vmw.700.1.0.15843807_19480755.zip','Net-Community-Driver_1.2.7.0.zip')
Expand-Archive -Path Net-Community-Driver_1.2.7.0.zip -DestinationPath ./Net-Community-Driver_1.2.7.0
PS > tree Net-Community-Driver_1.2.7.0
...
└── vib20
    └── net-community
        └── VMW_bootbank_net-community_1.2.7.0-1vmw.700.1.0.15843807.vib
  ```

#### Use script to customize iso file

```powershell
# use online base image
.\ESXi-Customizer-PS.ps1 -nsc -v80 -pkgDir ./vib20/net-community/ -iZip ESXi-8.0.0-20513097-standard.zip -ipname ESXi-8.0.0-net-community
# use offline base image
.\ESXi-Customizer-PS.ps1 -izip .\ESXi-8.0.0-20513097-standard.zip -nsc -v80 -pkgDir .\Net-Community-Driver_1.2.7.0-1vmw.700.1.0.15843807_19480755\vib20\net-community -ipname ESXi-8.0.0-net-community
```

> Reference

- [currently_available_ESXi_packages](https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages)
- [https://github.com/VFrontDe/ESXi-Customizer-PS](https://github.com/VFrontDe/ESXi-Customizer-PS)
- [https://oss.msft.vip/2023/02/10/custom-exsi-iso-with-Additional-driver/](https://oss.msft.vip/2023/02/10/custom-exsi-iso-with-Additional-driver/)

```powershell
# all available drivers can be found https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages
# script usage
PS /Users/jason> ./ESXi-Customizer-PS.ps1 -h
# generate custom exsi 6.0 with driver net-r8101 and sata-xahci
PS /Users/jason> ./ESXi-Customizer-PS.ps1 -v60 -load net-r8101,sata-xahci -vft -nsc -ipname ESXi-Customizer-exsi-60-net-r8101 
# generate custom exsi 6.7 with driver net55-r8168
PS /Users/jason> ./ESXi-Customizer-PS.ps1 -v67 -load net55-r8168 -vft -nsc -ipname ESXi-Customizer-exsi-67-net55-r8168
```
