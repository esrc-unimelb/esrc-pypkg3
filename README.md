pypkg
=====

A helper to create a custom, relocatable python 3


Invocation
==========
NAME="<whatever you want to call it>" && pypkg.sh <command>

where command is one of:

    One of: 
     - build: remove the existing build env (if exists) and build a new
     python and distribute / pip base.

     - clean: remove the existing build env (if exists) and the local
     instance of the Python tarball

     - install: install the pkgs

     - upgrade: upgrade the pkgs

     - pkg: build the debian pkg


That last one requires a suitable debian directory to exist.
