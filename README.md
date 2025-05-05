<p align="center">
  <img width="300" alt="Neopilot" src="neopilot.png"/>
</p>

---

[![Discord](https://img.shields.io/discord/1027685395649015980?label=community&color=5865F2&logo=discord&logoColor=FFFFFF)](https://discord.gg/3XFf78nAx5)
[![Twitter Follow](https://img.shields.io/badge/style--blue?style=social&logo=twitter&label=Follow%20%40neopilot_ai)](https://twitter.com/intent/follow?screen_name=neopilot_ai)
![License](https://img.shields.io/github/license/khulnasoft-com/neopilot.vim)
[![Docs](https://img.shields.io/badge/Neopilot%20Docs-09B6A2)](https://docs.neopilot.khulnasoft.com)
[![Canny Board](https://img.shields.io/badge/Feature%20Requests-6b69ff)](https://neopilot.canny.io/feature-requests/)
[![built with Neopilot](https://neopilot.khulnasoft.com/badges/main)](https://neopilot.khulnasoft.com?repo_name=khulnasoft-com%2Fneopilot.vim)

[![Visual Studio](https://img.shields.io/visual-studio-marketplace/i/Neopilot.neopilot?label=Visual%20Studio&logo=visualstudio)](https://marketplace.visualstudio.com/items?itemName=Neopilot.neopilot)
[![JetBrains](https://img.shields.io/jetbrains/plugin/d/20540?label=JetBrains)](https://plugins.jetbrains.com/plugin/20540-neopilot/)
[![Open VSX](https://img.shields.io/open-vsx/dt/Neopilot/neopilot?label=Open%20VSX)](https://open-vsx.org/extension/Neopilot/neopilot)
[![Google Chrome](https://img.shields.io/chrome-web-store/users/hobjkcpmjhlegmobgonaagepfckjkceh?label=Google%20Chrome&logo=googlechrome&logoColor=FFFFFF)](https://chrome.google.com/webstore/detail/neopilot/hobjkcpmjhlegmobgonaagepfckjkceh)

# neopilot.vim

_Free, ultrafast Copilot alternative for Vim and Neovim_

Neopilot autocompletes your code with AI in all major IDEs. We [launched](https://www.neopilot.khulnasoft.com/blog/neopilot-copilot-alternative-in-vim) this implementation of the Neopilot plugin for Vim and Neovim to bring this modern coding superpower to more developers. Check out our [playground](https://www.neopilot.khulnasoft.com/playground) if you want to quickly try out Neopilot online.

Contributions are welcome! Feel free to submit pull requests and issues related to the plugin.

<br />

![Example](https://user-images.githubusercontent.com/1908017/213154744-984b73de-9873-4b85-998f-799d92b28eec.gif)

<br />

## 🚀 Getting started

1. Install [Vim](https://github.com/vim/vim) (at least 9.0.0185) or [Neovim](https://github.com/neovim/neovim/releases/latest) (at
   least 0.6)

2. Install `khulnasoft-com/neopilot.vim` using your vim plugin manager of
   choice, or manually. See [Installation Options](#-installation-options) below.

3. Run `:Neopilot Auth` to set up the plugin and start using Neopilot.

You can run `:help neopilot` for a full list of commands and configuration
options, or see [this guide](https://www.neopilot.khulnasoft.com/vim_tutorial) for a quick tutorial on how to use Neopilot.

## 🛠️ Configuration

For a full list of configuration options you can run `:help neopilot`.
A few of the most popular options are highlighted below.

### ⌨️ Keybindings

Neopilot provides the following functions to control suggestions:

| Action                       | Function                       | Default Binding |
| ---------------------------  | ------------------------------ | --------------- |
| Clear current suggestion     | `neopilot#Clear()`              | `<C-]>`         |
| Next suggestion              | `neopilot#CycleCompletions(1)`  | `<M-]>`         |
| Previous suggestion          | `neopilot#CycleCompletions(-1)` | `<M-[>`         |
| Insert suggestion            | `neopilot#Accept()`             | `<Tab>`         |
| Manually trigger suggestion  | `neopilot#Complete()`           | `<M-Bslash>`    |
| Accept word from suggestion  | `neopilot#AcceptNextWord()`     | `<C-k>`         |
| Accept line from suggestion  | `neopilot#AcceptNextLine()`     | `<C-l>`         |

Neopilot's default keybindings can be disabled by setting

```vim
let g:neopilot_disable_bindings = 1
```

or in Neovim:

```lua
vim.g.neopilot_disable_bindings = 1
```

If you'd like to just disable the `<Tab>` binding, you can alternatively
use the `g:neopilot_no_map_tab` option.

If you'd like to bind the actions above to different keys, this might look something like the following in Vim:

```vim
imap <script><silent><nowait><expr> <C-g> neopilot#Accept()
imap <script><silent><nowait><expr> <C-h> neopilot#AcceptNextWord()
imap <script><silent><nowait><expr> <C-j> neopilot#AcceptNextLine()
imap <C-;>   <Cmd>call neopilot#CycleCompletions(1)<CR>
imap <C-,>   <Cmd>call neopilot#CycleCompletions(-1)<CR>
imap <C-x>   <Cmd>call neopilot#Clear()<CR>
```

Or in Neovim (using [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim#specifying-plugins) or [folke/lazy.nvim](https://github.com/folke/lazy.nvim)):

```lua
-- Remove the `use` here if you're using folke/lazy.nvim.
use {
  'khulnasoft-com/neopilot.vim',
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-g>', function () return vim.fn['neopilot#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['neopilot#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['neopilot#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['neopilot#Clear']() end, { expr = true, silent = true })
  end
}
```

(Make sure that you ran `:Neopilot Auth` after installation.)

### ⛔ Disabling Neopilot

Neopilot can be disabled for particular filetypes by setting the
`g:neopilot_filetypes` variable in your vim config file (vimrc/init.vim):

```vim
let g:neopilot_filetypes = {
    \ "bash": v:false,
    \ "typescript": v:true,
    \ }
```

Neopilot is enabled by default for most filetypes.

You can also _disable_ neopilot by default with the `g:neopilot_enabled` variable,
and enable it manually per buffer by running `:NeopilotEnable`:

```vim
let g:neopilot_enabled = v:false
```

or in Neovim:

```lua
vim.g.neopilot_enabled = false
```

Or you can disable neopilot for _all filetypes_ with the `g:neopilot_filetypes_disabled_by_default` variable,
and use the `g:neopilot_filetypes` variable to selectively enable neopilot for specified filetypes:

```vim
" let g:neopilot_enabled = v:true
let g:neopilot_filetypes_disabled_by_default = v:true

let g:neopilot_filetypes = {
    \ "rust": v:true,
    \ "typescript": v:true,
    \ }
```

If you would like to just disable the automatic triggering of completions:

```vim
let g:neopilot_manual = v:true

" You might want to use `CycleOrComplete()` instead of `CycleCompletions(1)`.
" This will make the forward cycling of suggestions also trigger the first
" suggestion manually.
imap <C-;> <Cmd>call neopilot#CycleOrComplete()<CR>
```

To disable automatic text rendering of suggestions (the gray text that appears for a suggestion):

```vim
let g:neopilot_render = v:false
```

### Show Neopilot status in statusline

Neopilot status can be generated by calling the `neopilot#GetStatusString()` function. In
Neovim, you can use `vim.api.nvim_call_function("neopilot#GetStatusString", {})` instead.
It produces a 3 char long string with Neopilot status:

- `'3/8'` - third suggestion out of 8
- `'0'` - Neopilot returned no suggestions
- `'*'` - waiting for Neopilot response

In normal mode, status shows if Neopilot is enabled or disabled by showing
`'ON'` or `'OFF'`.

In order to show it in status line add following line to your `.vimrc`:

```set statusline+=\{…\}%3{neopilot#GetStatusString()}```

Shorter variant without Neopilot logo:

```set statusline+=%3{neopilot#GetStatusString()}```

Please check `:help statusline` for further information about building statusline in VIM.

vim-airline supports Neopilot out-of-the-box since commit [3854429d](https://github.com/vim-airline/vim-airline/commit/3854429d99c8a2fb555a9837b155f33c957a2202).

### Launching Neopilot Chat

Calling the `neopilot#Chat()` function or using the `Neopilot Chat` command will enable search and indexing in the current project and launch Neopilot Chat in a new browser window.

```vim
:call neopilot#Chat()
:Neopilot Chat
```

The project root is determined by looking in Vim's current working directory for some specific files or directories to be present and goes up to parent directories until one is found.  This list of hints is user-configurable and the default value is:

```let g:neopilot_workspace_root_hints = ['.bzr','.git','.hg','.svn','_FOSSIL_','package.json']```

Note that launching chat enables telemetry.

## 💾 Installation Options

### 💤 Lazy

```lua
{
  'khulnasoft-com/neopilot.vim',
  event = 'BufEnter'
}
```

### 🔌 vim-plug

```vim
Plug 'khulnasoft-com/neopilot.vim', { 'branch': 'main' }
```

### 📦 Vundle

```vim
Plugin 'khulnasoft-com/neopilot.vim'
```

### 📦 packer.nvim:

```vim
use 'khulnasoft-com/neopilot.vim'
```

### 💪 Manual

#### 🖥️ Vim

Run the following. On windows, you can replace `~/.vim` with
`$HOME/vimfiles`:

```bash
git clone https://github.com/khulnasoft-com/neopilot.vim ~/.vim/pack/khulnasoft-com/start/neopilot.vim
```

#### 💻 Neovim

Run the following. On windows, you can replace `~/.config` with
`$HOME/AppData/Local`:

```bash
git clone https://github.com/khulnasoft-com/neopilot.vim ~/.config/nvim/pack/khulnasoft-com/start/neopilot.vim
```
