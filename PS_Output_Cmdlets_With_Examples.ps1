$cmds = Get-Command -Module msonline
$cmds | ForEach-Object{get-help $_ -Examples} >> MSOnlineCmdletsWithHelp.txt