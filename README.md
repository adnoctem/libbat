<p align="center">
    <!-- cmd -->
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://upload.wikimedia.org/wikipedia/en/7/7c/Batch_file_icon.png">
      <img src="https://upload.wikimedia.org/wikipedia/en/7/7c/Batch_file_icon.png" width="256">
    </picture>
    <h1 align="center">libbat</h1>
</p>

A library of open-source [MIT][license]-licensed Windows [Command Prompt][cmd] (`cmd`) [Batch (`bat`) scripts][cmd_bat] written and maintained by `Ad Noctem Collective` for use with modern Windows environments. Refer to Microsoft's [`cmd` Documentation][cmd_docs] for more information on how these scripts work. Scripts meant for direct execution by the user, an init system or other means of automation are located in the [`scripts`](scripts) directory. The [`lib`](lib) directory contains library scripts meant to be re-used across files or even different repositories with things like [Git Submodules][git_submodules] or _contrib_ scripts like [git_subtree]. You may of course take a look at other repositories of ours for tips on how to achieve re-use.

## ✨ TL;DR

```pwsh
# initialize the project (download dependencies)
git clone --recurse-submodules

# run a script
.\scripts\example.bat
```

### 🔃 Contributing

Contributions are welcome via GitHub's Pull Requests. Fork the repository and implement your changes within the forked
repository, after that you may submit a [Pull Request][gh_pr_fork_docs].

### 📥 Maintainers

This project is owned and maintained by [Ad Noctem Collective](https://github.com/adnoctem) refer to
the [`AUTHORS`](.github/AUTHORS) or [`CODEOWNERS`](.github/CODEOWNERS) for more information. You may also use the linked
contact details to reach out directly.

### ©️ Copyright

_Assets provided by:_ **[Microsoft Corporation][microsoft]**

<!-- File references -->

[license]: LICENSE

<!-- General links -->

[microsoft]: https://www.microsoft.com/

[cmd]: https://en.wikipedia.org/wiki/Cmd.exe

[cmd_bat]: https://en.wikipedia.org/wiki/Batch_file

[cmd_docs]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands

[git_submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules

[git_subtree]: https://www.atlassian.com/git/tutorials/git-subtree

[gh_pr_fork_docs]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork
