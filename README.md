# Jin Wei's neovim config

Adapted from [this blog post by vieitesss](https://vieitesss.github.io/posts/Neovim-new-config/) and [my old config](https://github.com/seetohjinwei/nvconf/tree/52218bb2a5775db7faf3d380cc06eb7abcbfd9f4).

## Installation

1. Install neovim 0.12+ from https://github.com/neovim/neovim/releases
2. Run the following commands as required

```sh
# Backup old neovim config
mv ~/.config/nvim ~/.config/nvim.bak

# Clear nvim data
rm -rf ~/.local/share/nvim

# Download this repository into `~/.config/nvim/`
mkdir -p ~/.config/nvim
git clone https://github.com/seetohjinwei/nvconf.git ~/.config/nvim

# Opening neovim installs everything else!
nvim
```
