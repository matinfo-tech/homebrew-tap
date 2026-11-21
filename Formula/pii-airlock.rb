class PiiAirlock < Formula
  include Language::Python::Virtualenv

  desc "Local privacy gateway that keeps PII out of LLM traffic"
  homepage "https://github.com/matinfo/pii-airlock"
  url "https://files.pythonhosted.org/packages/5d/f1/7c21da9f16541180c84a5d58a99cbc7537a9b5b823f5eee0ee2fe05849a7/pii_airlock-0.8.3.tar.gz"
  sha256 "80724dc72826db27eeb2e10d66843ab9c39954c18c6a467055ec64f73ac561c1"
  license "MIT"

  depends_on "python@3.12"

  def install
    # spaCy, Presidio and cryptography ship binary wheels with a long native
    # dependency tree: install them into one venv from PyPI rather than
    # vendoring every wheel as a `resource` block.
    venv = virtualenv_create(libexec, "python3.12")
    system libexec/"bin/python", "-m", "pip", "install", "#{buildpath}[proxy]"
    bin.install_symlink libexec/"bin/pii-airlock"
  end

  def caveats
    <<~EOS
      Detection needs spaCy models (not bundled). Download them once:
        pii-airlock download-models
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pii-airlock --version")
  end
end
