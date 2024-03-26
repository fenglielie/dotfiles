# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# get projectroot dir
$project_root_dir = "D:/ProjectRoot"

# .editorconfig
$editorconfig = "$project_root_dir/.editorconfig"
if (Test-Path -Path $editorconfig) {
    Write-Host "Error: File '$editorconfig' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $editorconfig -Target "$script_root_dir/editorconfig/.editorconfig" -Force
    Write-Host ".editorconfig config finished."
}

# .clang-format
$clang_format = "$project_root_dir/.clang-format"
if (Test-Path -Path $clang_format) {
    Write-Host "Error: File '$clang_format' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $clang_format -Target "$script_root_dir/clang/.clang-format" -Force
    Write-Host ".clang-format config finished."
}

# .clang-tidy
$clang_tidy = "$project_root_dir/.clang-tidy"
if (Test-Path -Path $clang_tidy) {
    Write-Host "Error: File '$clang_tidy' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $clang_tidy -Target "$script_root_dir/clang/.clang-tidy" -Force
    Write-Host ".clang-tidy config finished."
}
