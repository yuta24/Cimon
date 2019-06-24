require_relative 'cache/google_drive'

hash = %x(cat Cartfile.resolved Podfile.lock | openssl sha256).strip
file_name = "Cimon-#{hash}.tar.gz"

google_drive = GoogleDrive.new('1OU6TDa4CCrX3cSYqJjxCdueA3DEHXI9R')
google_drive.download(file_name)

system("tar xf #{file_name}")
system("rm #{file_name}")
