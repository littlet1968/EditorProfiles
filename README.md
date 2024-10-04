# EditorProfiles

My settings for Vim and Emacs

clone the repository like:
~]$ git clone https://github.com/littlet1968/EditorProfiles.git

Change into the directroy and copy/move the folders to the root of the home
~]$ cd EditorProfiles \n
EditorProfiles]$ cp -rv vim ~/.vim
EditorProfiles]$ cp -rv emacs.d ~/.emacs.d

For Vim create symbolic link to vimrc like
~]$ cd ~/
~]$ ln -s ~/.vim/vimrc .vimrc 

And update all submodules with
.vim]$ git submodule update --init --recursive



