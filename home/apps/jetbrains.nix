{ config, lib, pkgs, ... }:

let
  pycharm = pkgs.jetbrains.pycharm-professional.overrideAttrs (old: rec {
    version = "2025.3";
    src = pkgs.fetchurl {
      url = "https://download.jetbrains.com/python/pycharm-professional-${version}.tar.gz";
      sha256 = "sha256-pBDJxYNO3hY3MyXqIbhQ4wlVfbXZ3Mo2dMr5LqfFvwU=";
    };
  });
in
{
  home.packages = with pkgs; [
    pycharm
    jetbrains.webstorm
  ];

  # JetBrains IDEs Wayland configuration
  home.sessionVariables = {
    # use native Wayland for JetBrains IDEs
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # IdeaVim configuration
  xdg.configFile."ideavim/ideavimrc".text = ''
    " Addon Emulations
    set easymotion
    set surround
    set NERDTree

    " Editor Settings
    set number
    set relativenumber
    set hlsearch
    set smartcase
    set showcmd
    set showmode
    set ignorecase

    " Clipboard
    set clipboard+=unnamed
    set clipboard+=ideaput
    set clipboard+=unnamedplus

    " IdeaVim Settings
    set ideajoin
    set ideamarks

    " Leader
    let mapleader=" "

    " Key remappings - black hole register for change
    nnoremap c "_c
    nnoremap C "_C
    nnoremap cc "_cc
    nnoremap Y y$

    " No Highlight Map
    map <C-n> :nohl<CR>

    " JK Remap
    inoremap jk <esc>
    inoremap <esc> <nop>
    inoremap <C-c> <nop>

    " Format selection
    vmap <leader>f gq

    " Refactorings
    vmap T <Action>(Refactorings.QuickListPopupAction)
    nmap <leader>rr <Action>(RenameElement)
    nmap <leader>rg <Action>(Generate)
    nmap <leader>rI <Action>(OptimizeImports)
    nmap <leader>rc <Action>(InspectCode)
    nmap <leader>a <Action>(RecentChangedFiles)

    " Unimpaired mappings
    nnoremap [<space> O<esc>j
    nnoremap ]<space> o<esc>k
    nnoremap [q <Action>(PreviousOccurence)
    nnoremap ]q <Action>(NextOccurence)
    nnoremap [m <Action>(MethodUp)
    nnoremap ]m <Action>(MethodDown)
    nnoremap [c <Action>(VcsShowPrevChangeMarker)
    nnoremap ]c <Action>(VcsShowNextChangeMarker)
    nnoremap [b <Action>(PreviousTab)
    nnoremap ]b <Action>(NextTab)
    nmap [e <Action>(MoveLineUp)
    nmap ]e <Action>(MoveLineDown)
    nmap [s <Action>(MoveStatementUp)
    nmap ]s <Action>(MoveStatementDown)

    " Search
    nmap <leader>/ <Action>(Find)
    nmap <leader>\ <Action>(FindInPath)

    " IDE Actions
    map <leader>h <Action>(QuickJavaDoc)
    map <leader>e <Action>(ShowErrorDescription)
    map <leader>p <Action>(ReformatCode)
    map <leader>c <Action>(ShowPopupMenu)
    map <leader>j <Action>(FileStructurePopup)

    if &ide =~? 'webstorm'
        map <leader>p <Action>(ReformatWithPrettierAction)<CR><Action>(ReformatCode)
    endif

    " Code navigation (leader c)
    nnoremap <leader>cd :action GotoDeclaration<cr>
    nnoremap <leader>ct :action GotoTypeDeclaration<cr>
    nnoremap <leader>ci :action GotoImplementation<cr>
    nnoremap <leader>cs :action GotoSuperMethod<cr>
    nnoremap <leader>cr :action ShowUsages<cr>
    nnoremap <leader>cu :action HighlightUsagesInFile<cr>
    nnoremap <leader>cv :action QuickJavaDoc<cr>
    nnoremap <leader>cc :action CallHierarchy<CR>
    nnoremap <leader>cn :action ShowNavBar<CR>
    nnoremap <leader>cx :action FileStructurePopup<CR>
  '';
}
