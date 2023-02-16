# Customize EXSi ISO With required Network Drivers

If you want to use `GitHub Actions` yourself, your need add own `TOKEN` to `Secrets`

> check the hardware of which network driver you need

```bash
[jason@bo ~]$ lspci | grep -i Ethernet
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
```

> Make Sure Exsi version which compatible with the driver

Supported driver list:

https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages

```yaml
- name:  Generate EXSi6.0 with Driver sata-xahci,net55-r8168
  shell: powershell
  run: |
    cd $WORK_DIR
    .\ESXi-Customizer-PS.ps1 -nsc -v60 -vft -load sata-xahci,net55-r8168 -ipname ${{ github.event.inputs.tag }} -outDir ..\ -log ..\buildlog.txt
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
