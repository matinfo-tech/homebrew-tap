# homebrew-tap

Homebrew formulae for [pii-airlock](https://github.com/matinfo-tech/pii-airlock).

```bash
brew install matinfo/tap/pii-airlock
pii-airlock download-models   # spaCy models, downloaded once
```

The formula installs pii-airlock (CLI, hooks, gateway, Word and PDF support) into
its own virtualenv, on Python 3.12. The models live outside it, in
`~/.local/share/pii-airlock/models`, so `brew upgrade` keeps them (from 0.9.0).
GLiNER is not included: add it with
`"$(brew --prefix pii-airlock)/libexec/bin/python" -m pip install 'pii-airlock[gliner]'`
(again after each upgrade), or use pipx.
