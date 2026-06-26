class ClaudeStatusbar < Formula
  desc "macOS menu-bar dashboard light for Claude Code"
  homepage "https://github.com/rikenpatel20/claude-statusbar"
  url "https://github.com/rikenpatel20/claude-statusbar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "435c48198df99ee2eeee2b50d062f787ab1c2dbfa48d8e47970bc2400f94d0c8"
  license "MIT"

  depends_on :macos

  def install
    # Ship the whole tree; install.sh resolves its siblings relative to itself.
    libexec.install Dir["*"]

    # Thin wrapper so `claude-statusbar [--write-settings]` runs the installer
    # from its libexec home (where src/, assets/, scripts/ all live).
    (bin/"claude-statusbar").write <<~SH
      #!/bin/bash
      exec /bin/bash "#{libexec}/install.sh" "$@"
    SH
  end

  def caveats
    <<~EOS
      claude-statusbar needs SwiftBar (free, open source) as its menu-bar host:
        brew install --cask swiftbar

      Then finish setup — installs the scripts + SwiftBar plugin and merges the
      hooks/status line into ~/.claude/settings.json (backed up first):
        claude-statusbar --write-settings

      Restart Claude Code; the icon appears as soon as a session is active.
      Run `claude-statusbar` with no flag to print the settings snippet instead
      of writing it.
    EOS
  end

  test do
    assert_path_exists libexec/"install.sh"
    system "/usr/bin/python3", "-m", "py_compile", libexec/"src/claude.2s.py"
  end
end
