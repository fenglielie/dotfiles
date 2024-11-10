# echo "call mysetup.fish"

if status is-interactive
    # echo "hello, fish"
end

set -U __fish_initialized 3100

set -U fish_color_autosuggestion 707A8C
set -U fish_color_cancel \x2dr
set -U fish_color_command 5CCFE6
set -U fish_color_comment 5C6773
set -U fish_color_cwd 73D0FF
set -U fish_color_cwd_root red
set -U fish_color_end F29E74
set -U fish_color_error FF3333
set -U fish_color_escape 95E6CB
set -U fish_color_history_current \x2d\x2dbold
set -U fish_color_host normal
set -U fish_color_host_remote yellow
set -U fish_color_match F28779
set -U fish_color_normal CBCCC6
set -U fish_color_operator FFCC66
set -U fish_color_param CBCCC6
set -U fish_color_quote BAE67E
set -U fish_color_redirection D4BFFF
set -U fish_color_search_match \x2d\x2dbackground\x3dFFCC66
set -U fish_color_selection \x2d\x2dbackground\x3dFFCC66
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path \x2d\x2dunderline

set -U fish_key_bindings fish_default_key_bindings

set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D\x1eyellow
set -U fish_pager_color_prefix normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
set -U fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan

# close default greeting message
set -U fish_greeting

# alias
abbr -a ll ls -alF
abbr -a la ls -A
abbr -a l ls -CF
abbr -a n nvim


