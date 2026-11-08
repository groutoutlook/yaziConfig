# `yazi` config
- Annually change, hope so.

Requires Yazi 26.9.1 or newer (the openers use `%s` file arguments).

- `Enter` / `o`: open with the system-associated application, including text files.
- `O` / `Shift+Enter`: choose an opener, including the blocking Helix editor.
- Select files with `Space` or `v`, then press `r` or `R` to batch rename. Edit one
  filename per line in Helix, save and quit (`:wq`), then confirm the rename in Yazi.
  `R` also opens the rename list for a single hovered file.
- `;`: run a command in the preferred shell and show plain-text output in a notification.
- `:`: run a command with the terminal available for input and output.
- `!`: open an interactive shell in the current directory; `exit` returns to Yazi.

The preferred shell is PowerShell (`pwsh`, falling back to `powershell`) on Windows
and `$SHELL` on Unix (for example, Nushell). Set `YAZI_SHELL` before starting Yazi
to override it; use an executable name or path without arguments. Commands use
that shell's native syntax and paths, rather than Yazi's `%s` placeholders.
For example, set `$env:YAZI_SHELL = 'nu'` in PowerShell or
`$env.YAZI_SHELL = 'nu'` in Nushell.

Batch rename always waits for the editor to close. On Unix it uses `$EDITOR`
(falling back to `hx`); on Windows it uses `hx`.
