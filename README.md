# Customize EXSi ISO With required Network Drivers

If you want to use `GitHub Actions` yourself, your need add own `TOKEN` to `Secrets`

> check the hardware of which network driver you need

```bash
[jason@bo ~]$ lspci | grep -i Ethernet
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
```

> How to use this action to build exsi on your own

-  change the default driver

```yaml
- name: Customize drivers
  shell: powershell
    run: |
      ...
      # change the driver name you need base on https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages
      $env:VIB='sata-xahci,net55-r8168'
      $env:VIB
```
- change exsi version which compatible with the driver

```yaml
- name:  Generate EXSi ISO File
  shell: powershell
  run: |
    ...
    # change exsi version like -v60,-v65,-v67,-v70..., more Supportbility ./ESXi-Customizer-PS.ps1 -h
    .\ESXi-Customizer-PS.ps1 -nsc -v60 -vft -load $env:VIB -ipname ${{ github.event.inputs.tag }}_${{ github.event.inputs.driver }} -outDir ..\ -log buildlog.txt
    dir ..\
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
