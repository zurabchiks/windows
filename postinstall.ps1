# Чтобы активировать сервер с граф. интерфейсом:
start slui

# Для администрирования и запроса информации о лицензиях на компьютерах Windows Server, существует скрипт SLMGR.VBS, который вы можете запустить с различными опциями:
# /ato - Активировать Windows онлайн
# /dli - Отображать текущую информацию о лицензии
# /dlv - Более детальная информация о лицензии
# /dlv all - Информация по всем установленным лицензиям

# Для просмотра текущей установленной редакции:
dism /online /Get-CurrentEdition

# Проверка установки драйверов:
devmgmt.msc

# Для получения подробного обзора встроенного оборудования ПК:
msinfo32

# systemInfo - используется для отображения всей информации о компьютере в командной строке.
# Чтобы сохранить ее в файл, выполните:
systeminfo /FO list > C:\sysinfo.txt

# Просмотр настроек сетевой карты:
ncpa.cpl

# Установка языковых пакетов:
lpksetup

# Чтобы отключить Media Player:
dism /online /Disable-Feature /FeatureName:WindowsMediaPlayer /norestart

# Для переименования компьютера, добавление его в домен и включение удаленого доступа:
sysdm.cpl

# Проверка подключенных пользователей с помощью:
qwinsta

# Чтобы восстановить менеджер загрузки:
bcdboot C:\Windows /s C: /f BIOS
bootsect.exe /nt60 ALL /force
bootsect.exe /nt60 C: /mbr /force

# Чтобы установить git, выполните:
start msedge https://git-scm.com/download/win 

# Чтобы выполнить sysprep:
sl C:\Windows\System32\sysprep
.\sysprep.exe /oobe /generalize /shutdown /mode:vm 

### VM1 ###

New-VHD -ParentPath "D:\VM\_disks\win22ru.vhdx" -Path e:\vm\vm1.vhdx -Differencing -Verbose
New-VM -Name vm1 -MemoryStartupBytes 3Gb -VHDPath e:\vm\vm1\vm1.vhdx -Path e:\vm\vm1 -Generation 1 -SwitchName Ext

set-vm vm1 -CheckpointType Disabled 
start-vm vm1

# Enter-PSSession 
$Credentials=Get-Credential
etsn -VMName vm1 -Verbose -Credential $Credentials

# Rename and add to the domain 
Rename-Computer vm1 -Verbose -Restart -Force 

# Network Adapter Settings 
Get-NetAdapter
# Check for InterfaceIndex and set it in below commands accordingly "-InterfaceIndex" #"
New-NetIPAddress -IPAddress 192.168.1.22 -DefaultGateway 192.168.1.1 -PrefixLenght 24 -InterfaceIndex 16
Set-DNSClientServerAddress -InterfaceIndex 16 -ServerAddress 127.0.0.1, 192.168.1.1

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "domain.com" -DomainNetbiosName "dmn" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true

# Add to Domain domain.com
Add-Computer -DomainName domain.com -Credential dmn\administrator -Verbose -Restart -Force

# Create DMN lab checkpoints 
stop-vm vm1, vm2 -Force 
set-vm vm1, vm2 -CheckpointType Standard
set-VM -Name vm1, vm2 -AutomaticCheckpointsEnabled $false 
checkpoint-VM -Name vm1, vm2 -SnapshotName 'base domain.com lab'

# Remove VMs
stop-vm vm1 -Force 
Remove-VM vm1 -Force
Remove-Item -Recurse e:\vm\vm1 -Force
Remove-Item -Recurse e:\vm\vm1 -Force