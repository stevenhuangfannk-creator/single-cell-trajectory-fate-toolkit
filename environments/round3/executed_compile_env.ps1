# 仅配置当前进程。不写系统环境或默认 R 配置。
$env:LANG='English_United States.utf8'
$env:LC_ALL=$env:LANG
$env:PROCESSOR_ARCHITECTURE='AMD64'
$env:OMP_NUM_THREADS='1'
$env:OPENBLAS_NUM_THREADS='1'
$env:MKL_NUM_THREADS='1'
$env:MAKEFLAGS='-j1'
$env:ENABLE_INSTALL_COUNTING='no'
$env:RTOOLS45_HOME=($PWD.Path+'/work/runtime/rtools45').Replace('\','/')
$env:R_CUSTOM_TOOLS_SOFT=$env:RTOOLS45_HOME+'/x86_64-w64-mingw32.static.posix'
$env:R_CUSTOM_TOOLS_PATH=$env:R_CUSTOM_TOOLS_SOFT+'/bin;'+$env:RTOOLS45_HOME+'/msys/usr/bin;C:/Program Files/Git/usr/bin'
$env:PATH=$env:R_CUSTOM_TOOLS_PATH+';'+$PWD.Path+'/work/runtime/R-4.6.1/bin/x64;'+$env:PATH
$env:R_MAKEVARS_USER=($PWD.Path+'/work/round3/Makevars').Replace('\','/')
$env:R_LIBS_USER=($PWD.Path+'/work/runtime/R-trajectory/library').Replace('\','/')
if(Test-Path 'Q:/rtools45/x86_64-w64-mingw32.static.posix') {
  # GCC 在深目录中无法打开部分 >260 字符的头文件；Q: 只映射当前工作区 runtime。
  $env:CPLUS_INCLUDE_PATH='Q:/rtools45/x86_64-w64-mingw32.static.posix/lib/gcc/x86_64-w64-mingw32.static.posix/14.3.0/include/c++/x86_64-w64-mingw32.static.posix;Q:/R-trajectory/library/RcppEigen/include;Q:/R-trajectory/library/Rcpp/include'
}
