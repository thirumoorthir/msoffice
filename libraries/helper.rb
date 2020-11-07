module EBT
  module Helpers
    include Chef::Mixin::PowershellOut

    def remote_desktop_session_host?
      win_version = Chef::ReservedNames::Win32::Version.new

      if win_version.windows_server_2008_r2? || win_version.windows_server_2012? || win_version.windows_server_2012_r2? || win_version.windows_server_2016? || win_version.windows_server_2019?
        cmd = powershell_out!('Get-WindowsFeature RDS-RD-Server', returns: [0, 2])
        cmd.stderr.empty? && (cmd.stdout =~ /Install/)
      else
        puts 'Does not support RDSH'
        return false
      end
    end
  end
end
