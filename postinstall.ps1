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