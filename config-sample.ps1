# modify and copy me to config.ps1
$config = @{
  User = "<user name>";
  Password = "<password (yes, in plain text)>";
  GitRepo = "<url to git repo; if using ssh keys, obviously the user RUNNING this script must have the key>";
  BaseUrl = "http://tfs-server/CollectionName/ProjectName/_apis";
  BuildDefinitionId = 42; # change to match your build definition id
  BuildReason = "Build queued by an unfeeling scriptoid";
}