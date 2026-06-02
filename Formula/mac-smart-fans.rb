class MacSmartFans < Formula
  desc "Temperature-driven fan control for Apple Silicon Macs"
  homepage "https://github.com/marshallku/mac-smart-fans"
  version "0.2.0"
  url "https://github.com/marshallku/mac-smart-fans/releases/download/v0.2.0/msf-darwin-arm64"
  sha256 "eed678ab0498fe3f2205c2d9a92b8673a8838f7987d4c582d1961f001fcadd6e"
  license :cannot_represent

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "msf-darwin-arm64" => "msf"
  end

  def caveats
    <<~EOS
      msf set/run/install require root (SMC writes).

      To skip the password prompt for `sudo msf …`, add a NOPASSWD entry:

        sudo tee /etc/sudoers.d/msf-#{ENV["USER"]} <<EOF
        #{ENV["USER"]} ALL=(root) NOPASSWD: #{HOMEBREW_PREFIX}/bin/msf
        EOF
        sudo chmod 0440 /etc/sudoers.d/msf-#{ENV["USER"]}
        sudo visudo -c -f /etc/sudoers.d/msf-#{ENV["USER"]}

      To install the persistent daemon (curve loop on boot, all fans by default):

        msf init --profile balanced -o ~/.config/msf/curve.toml
        sudo msf install --curve ~/.config/msf/curve.toml
        msf status

      Full install + uninstall guide:
        https://github.com/marshallku/mac-smart-fans/blob/master/INSTALL.md
    EOS
  end

  test do
    assert_match "msf 0.2.0", shell_output("#{bin}/msf --version")
  end
end
