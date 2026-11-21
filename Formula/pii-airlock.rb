class PiiAirlock < Formula
  include Language::Python::Virtualenv

  desc "Local privacy gateway that keeps PII out of LLM traffic"
  homepage "https://pii-airlock.matinfo.tech/"
  url "https://files.pythonhosted.org/packages/43/01/95288bfa823a6fccc66131f5da2c638eea0df66f682293050f3642853445/pii_airlock-0.9.0.tar.gz"
  sha256 "6d76b6db2a9dee6e0a58485ec35510f18aad1ed5813a3f2b3d501b12b72ba4b4"
  license "MIT"

  depends_on "python@3.12"

  def install
    # spaCy, Presidio and cryptography ship binary wheels with a long native
    # dependency tree: install them into one venv from PyPI rather than
    # vendoring every wheel as a `resource` block.
    # python@3.12, not the newest Python: spaCy 3.8 cannot load models on 3.15.
    virtualenv_create(libexec, "python3.12")
    # [proxy] brings the gateway up to 0.8.x; from 0.9.0 it is in the core (the extra is empty).
    system libexec/"bin/python", "-m", "pip", "install", "#{buildpath}[proxy]"
    bin.install_symlink libexec/"bin/pii-airlock"
  end

  def caveats
    <<~EOS
      Detection needs spaCy models (not bundled). Download them once:
        pii-airlock download-models
      From 0.9.0 they are stored in ~/.local/share/pii-airlock/models, outside
      Homebrew's prefix, so `brew upgrade` keeps them. Check the setup with:
        pii-airlock doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pii-airlock --version")
  end
end
