Get-ADUser -Filter * -Properties *| Select-Object name | export-csv -Path "C:\Users\Administrateur\Documents\userad.csv" -Encoding UTF8
$listAD= Import-CSV -Path "C:\Users\Administrateur\Documents\userad.csv"
foreach($item in $listAD){

$fullpath = "\Users\{0}" -f $item.name
$driveletter = "C:"
$User = Get-ADUser -Identity $item.name
if($User -ne $Null){
    Set-ADUser $User -HomeDrive $driveletter -HomeDirectory $fullpath -ea Stop
    $homeShare = New-Item -path $fullpath -ItemType Directory -force -ea Stop
}
$acl = (Get-Item $homeShare).GetAccessControl("Access")
" Création du chemain d'accès pour $item.name .."
$FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
$AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
$InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
$AccessRule=New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
" Contrôle des permissions .."
$acl.AddAccessRule($AccessRule)
Set-Acl -Path $homeShare -AclObject $acl -ea Stop
"Le répertoire de $User à été créer"
}