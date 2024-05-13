# scripts
各种脚本

## windows 安装清单
```bash
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install firacode
scoop install bat curl dark docker firacode fzf git-aliases grep innounp jq lazygit less lunarvim neovim python sed sudo touch vim wezterm which winget wixtoolset 7zip git openssh pwsh
```

后置操作：
1. 配置 git 国内代理，方便拉取 neovim plugin：`git config --global url."https://mirror.ghproxy.com/https://github.com/".insteadof "https://github.com/"`
2. 手动执行 lunarvim 安装脚本: `~/scoop/app/lunarvim/current/install.ps1`


## 参考
- [LazyVim 国内安装一些问题的解决办法](https://zhuanlan.zhihu.com/p/692316649)
