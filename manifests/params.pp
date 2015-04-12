#  Parameters
#
#    mortal         = name of non uid 0 user account to create
#    mortal_key     = ssh key
#    mortal_keytype = key type (ssh-rsa/ssh-dsa)
#    r2domain       = domain name of server
#    r2hname        = server hostname
#    timezone       = timezone
#                     http://en.wikipedia.org/wiki/List_of_tz_database_time_zones

class puppet_radare2::params {

  $mortal         = 'echo'
  $mortal_key     = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMFMTyIZmjBIuSTE93iDgWio/TdjNI5GFsK9zeqv8sIx/O1XlIp71EB6+AKq8CyR8M6ydc8VjW9eZWU3naXQ3/ydTZENa2XmPmtdXw1M94LtgB57aiOJoiaT8hp9q40rHg8ouPNRCmkAvD5nGjJMrlqDAZkjnYHuy0Gze4qO/zNp2JPzaQx3avhLW1vW7n8xiY0k+yMSdMF9a82z7V0L/fKto6anTMsPMeSNiFTF2ixrdQesvi7mJlU0h/0lHuV5Q4bzLVV4WcNlJ/D3/4b7DD47zZU0CT/vQ+ceDPMpKPwJyZYUMNhPk9Yi9BRdaUgxtFfYFTb7xqdPH5LfcZeLw3'
  $mortal_keytype = 'ssh-rsa'
  $r2domain       = 'tacoshells.net'
  $r2hname        = 'salsa'
  $timezone       = "America/Los_Angeles\n"
}
