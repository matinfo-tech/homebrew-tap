class PiiAirlock < Formula
  include Language::Python::Virtualenv

  desc "Local privacy gateway that keeps PII out of LLM traffic"
  homepage "https://pii-airlock.matinfo.tech/"
  url "https://files.pythonhosted.org/packages/5d/f1/7c21da9f16541180c84a5d58a99cbc7537a9b5b823f5eee0ee2fe05849a7/pii_airlock-0.8.3.tar.gz"
  sha256 "80724dc72826db27eeb2e10d66843ab9c39954c18c6a467055ec64f73ac561c1"
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
