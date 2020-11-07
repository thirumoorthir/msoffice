# # encoding: utf-8

# Inspec test for recipe office2016::configure

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

return unless os.windows?

cmd_to_run = powershell('Get-WindowsFeature RDS-RD-Server | Select -ExpandProperty InstallState').stdout
has_rdsh = cmd_to_run.downcase.match?(/installed/)

if os.name =~ /server/ && has_rdsh
  describe registry_key('HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration') do
    it { should have_property 'SharedComputerLicensing' }
    its('SharedComputerLicensing') { should eq "1" }
  end
else
  describe registry_key('HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration') do
    it { should_not have_property 'SharedComputerLicensing' }
  end
end
