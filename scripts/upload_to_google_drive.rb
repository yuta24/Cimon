require_relative 'cache/google_drive'

hash = %x(cat Cartfile.resolved Podfile.lock | openssl sha256).strip
file_name = "Cimon-#{hash}.tar.gz"
system("tar czf #{file_name} Carthage/Build Pods")

google_drive = GoogleDrive.new('1OU6TDa4CCrX3cSYqJjxCdueA3DEHXI9R')
google_drive.upload(file_name)

system("rm #{file_name}")
