Set-PSReadLineKeyHandler -Key "Ctrl+q" -Function MenuComplete

Import-Module posh-git
#Import-Module oh-my-posh
Import-Module Get-ChildItemColor
# Set-Theme UMU-Light

function ll { Get-ChildItem -Force $args }

function gcam { & git commit -am $args }
function gpl { & git pull $args }
function gph { & git push $args }
function grv { & git remote -v }
function gs { & git status }

$env:GO111MODULE = "on"
$env:GOPROXY = "https://goproxy.cn"
