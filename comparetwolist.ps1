Rem
Get-ADUser -Filter * -Properties *| Select-Object name | export-csv -Path "C:\Users\Administrateur\Documents\userad.csv" -Encoding UTF8
$listCSV= Import-CSV -Path "C:\Users\Administrateur\Documents\liste.csv"
$listAD= Import-CSV -Path "C:\Users\Administrateur\Documents\userad.csv"
$ErrorActionPreference = "silentlycontinue"
"  "
"On désactive tous le monde .."
"  "
foreach($desatout in $listAD){
    Set-ADUser -Identity $desatout.name -Enabled $false -PasswordNotRequired $true}

"On compare la liste de ceux qui existe et de ceux ne sont plus là .."
"  "
Compare-Object -ReferenceObject $listCSV -IncludeEqual -ExcludeDifferent $listAD | Select-Object -ExpandProperty InputObject | Export-Csv "C:\Users\Administrateur\Documents\diff.csv" -NoTypeInformation
$listdiff = Import-CSV -Path "C:\Users\Administrateur\Documents\diff.csv"

"On active les personnes qui sont toujours présent sur la liste .. "
"  "
foreach($item in $listdiff){
    Set-ADUser -Identity $item.name -Enabled $true -PasswordNotRequired $true
    }
