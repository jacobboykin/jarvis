source ~/.config/nvim/plugins.vim

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Remap leader key to ,
let mapleader=","

" Line Numbers
set nu

" Yank and paste with the system clipboard
set clipboard=unnamed

" Hides buffers instead of closing them
set hidden

" === TAB/Space settings === "
" Insert spaces when TAB is pressed.
set expandtab

" Change number of spaces that a <Tab> counts for during editing ops
set softtabstop=2

" Indentation amount for < and > commands.
set shiftwidth=2

" do not wrap long lines by default
set nowrap

" Highlight current line
set nocursorline

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'auto_resize': 1,
\ 'prompt': 'λ:',
\ 'direction': 'rightbelow',
\ 'winminheight': '10',
\ 'highlight_mode_insert': 'Visual',
\ 'highlight_mode_normal': 'Visual',
\ 'prompt_highlight': 'Function',
\ 'highlight_matched_char': 'Function',
\ 'highlight_matched_range': 'Normal'
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for fname in keys(a:opts)
    for dopt in keys(a:opts[fname])
      call denite#custom#option(fname, dopt, a:opts[fname][dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo "Denite not installed. It should work after running :PlugInstall"
endtry

" === Deoplete === "
" Enable deoplete at startup
let g:deoplete#enable_at_startup = 1

" Use smartcase
let g:deoplete#enable_smart_case = 1

" Set minimum syntax keyword length.
let g:deoplete#sources#syntax#min_keyword_length = 2

" Set deoplete sources for javascript
call deoplete#custom#source('omni', 'functions', {
\ 'javascript': ['tern#Complete', 'jspc#omni']
\})

" Disable autocomplete inside of comments
call deoplete#custom#source('_',
\ 'disabled_syntaxes', ['Comment', 'String'])

" === Deoplete-ternjs ==="

" Use same tern command as tern_for_vim
let g:tern#command = ['tern']

" Ensure tern server doesn't shut off after 5 minutes for performance
let g:tern#arguments = ['--persistent']

" Include the types of completions in result data
let g:deoplete#sources#ternjs#types = 1

" Include documentation strings (if found) in the result data
let g:deoplete#sources#ternjs#docs = 1

" Stop ternjs from guessing at matches if it doesn't know
let g:deoplete#sources#ternjs#guess = 0

" Close preview window after completion is made
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" === NeoSnippet === "
" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)

" INSERT MODE:
" <TAB> will jump into autocomplete menu if it is visible
" OR, it will move to next available snippet field if available
imap <expr><TAB>
\ pumvisible() ? "\<C-n>" :
\ neosnippet#expandable_or_jumpable() ?
\   "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Expand the snippet trigger from autocomplete menu with <CR>
imap <expr><CR>
\ (pumvisible() && neosnippet#expandable()) ?
\   "\<Plug>(neosnippet_expand)" : "\<CR>"

" SELECT MODE:
" Use <TAB> to move to next snippet field if available
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" === NERDTree === "
" Show hidden files/directories
let NERDTreeShowHidden=1

" Custom icons for expandable/expanded directories
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'

" Hide certain files and directories from NERDTree
let NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']

" === Ale === "
" Enable language-specif linters
let g:ale_linters = {
\ 'vim' : ['vint'],
\ 'javascript' : ['eslint']
\ }

" Customize warning/error signs
let g:ale_sign_error = '⁉'
let g:ale_sign_warning = '•'

" Custom error format
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Don't lint on text change, only on save
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1

" === vim-javascript === "
" Enable syntax highlighting for JSDoc
let g:javascript_plugin_jsdoc = 1

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" === javascript-libraries-syntax === "
let g:used_javascript_libs = 'underscore,requirejs,chai,jquery'

" === vim-devicons === "
" Don't use icons for Denite as it has render issues
" and potential performance issues
let g:webdevicons_enable_denite = 0

" === echdoc === "
" Enable echodoc at startup
let g:echodoc#enable_at_startup = 1

" === vim-gitgutter === "
let g:gitgutter_override_sign_column_highlight = 0

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set termguicolors

" Editor theme
set background=dark
try
  colorscheme OceanicNext
  " Make end of buffer char (~) less noticeable
  hi! EndOfBuffer ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#041123
catch
  colorscheme slate
endtry

" Add custom highlights in method that is executed every time a
" colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f for
" details
function! MyHighlights() abort
  " Hightlight trailing whitespace
  highlight Trail ctermbg=red guibg=red
  call matchadd('Trail', '\s\+$', 100)
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

" Change vertical split character to be a space (essentially hide it)
set fillchars+=vert:.

" Set preview window to appear at bottom
set splitbelow

" Don't dispay mode in command line (airilne already shows it)
set noshowmode

" Make background transparent
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermfg=NONE guibg=NONE
hi! SignColumn ctermfg=NONE guibg=NONE
hi! VertSplit gui=NONE guifg=#1b202a guibg=NONE
hi! StatusLine gui=NONE guifg=#BBBBBB guibg=NONE
hi! StatusLineNC gui=NONE guifg=#BBBBBB guibg=NONE

" Remove background colors for warnings/errors in gutter from Ale
hi! ALEErrorSign ctermbg=none guibg=NONE
hi! ALEWarningSign ctermfg=NONE guibg=NONE

" Make background color transparent for git gutter
hi! GitGutterAdd guibg=NONE
hi! GitGutterChange guibg=NONE
hi! GitGutterDelete guibg=NONE
hi! GitGutterChangeDelete guibg=NONE

" Display errors from Ale in statusline
function! LinterStatus() abort
   let l:counts = ale#statusline#Count(bufnr(''))
   let l:all_errors = l:counts.error + l:counts.style_error
   let l:all_non_errors = l:counts.total - l:all_errors
   return l:counts.total == 0 ? '' : printf(
   \ 'W:%d E:%d',
   \ l:all_non_errors,
   \ l:all_errors
   \)
endfunction

" Configure custom status line
set laststatus=2
set statusline=
set statusline+=\ %f\ %*
set statusline+=%=
set statusline+=\ %{LinterStatus()}

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and
"   close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
"   <leader>d - Delete item under cursor (useful for delete buffers in normal mode)
nmap ; :Denite buffer<CR>
nmap <leader>t :Denite file_rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty -mode=normal<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:. -mode=normal<CR>

" === Nerdtree shorcuts === "
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

"   <Space> - PageDown
"   -       - PageUp
noremap <Space> <PageDown>
noremap - <PageUp>

" === vim-better-whitespace === "
"   <leader>y - Automatically remove trailing whitespace
nmap <leader>y :StripWhitespace<CR>

" === Search shorcuts === "
"   <leader>h - Find and replace
"   <leader>/ - Claer highlighted search terms while preserving history
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>

" === Easy-motion shortcuts ==="
"   <leader>w - Easy-motion highlights first word letters bi-directionally
map <leader>w <Plug>(easymotion-bd-w)

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" === vim-jsdoc shortcuts ==="
" Generate jsdoc for function under cursor
nmap <leader>z :JsDoc<CR>

" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to
" Vim's default buffer
vnoremap <leader>p "_dP

" === tern_for_vim === "
" Jump to the definition of the thing under cursor
nmap <leader>dj :TernDef<CR>

" Show all references to the variable or property under the cursor
nmap <leader>dr :TernRefs<CR>

" Rename the variable under cursor
nmap <leader>dn :TernRename<CR>

" Look up documentation of thing under cursor
nmap <leader>dd :TernDoc<CR>

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

" Refresh vim-devicons to ensure they render properly (fixes render issues
" after sourcing config file)
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Automatically re-read file if a change was detected outside of vim
set autoread

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile
