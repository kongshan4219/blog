---
title: "安装pyenv"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-15# #lastmod/2024-09-15#

---

### 自动安装

~~~
curl https://pyenv.run | bash
~~~

### 完成后需要添加到shell环境

~/.bashrc

~~~
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
~~~

~/.profile

~~~
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
~~~

~/.bash_profile

~~~
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
~~~

### 刷新shell

~~~
exec $SHELL
~~~

### das

```ini
   commands     List all available pyenv commands
   local        Set or show the local application-specific Python version
   latest       Print the latest installed or known version with the given prefix
   global       Set or show the global Python version
   shell        Set or show the shell-specific Python version
   install      Install 1 or more versions of Python
   uninstall    Uninstall 1 or more versions of Python
   update       Update the cached version DB
   rehash       Rehash pyenv shims (run this after switching Python versions)
   vname        Show the current Python version
   version      Show the current Python version and its origin
   version-name Show the current Python version
   versions     List all Python versions available to pyenv
   exec         Runs an executable by first preparing PATH so that the selected 
                Python version's `bin' directory is at the front
   which        Display the full path to an executable
   whence       List all Python versions that contain the given executable
```
