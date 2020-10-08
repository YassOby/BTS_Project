$liste = Import-CSV -Path "C:\Users\Administrateur\Documents\liste.csv" -Delimiter ";"
#$listAD= Import-CSV -Path "C:\Users\Administrateur\Documents\userad.csv"

foreach($item in $liste){
    $Name = $item.name
    $Surname = $item.surname
    New-ADUser -Name $Name -Surname $Surname -PasswordNotRequired $true -Enabled $true}
