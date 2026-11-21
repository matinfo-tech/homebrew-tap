class PiiAirlock < Formula
  include Language::Python::Virtualenv

  desc "Local privacy gateway that keeps PII out of LLM traffic"
  homepage "https://pii-airlock.matinfo.tech/"
  url "https://files.pythonhosted.org/packages/67/b4/5449d16181d6d416f510ed0096eea551be0c69a2049e86305053850d39aa/pii_airlock-0.9.2.tar.gz"
  sha256 "ad84b6af98bc9a8eebd00cd6510ccd739577ecf9468231f85c2343088bf580e2"
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
