#!/bin/bash


DEST="/usr/local/scholarly-python3"
VERSION="3.6.5"

PKGS="distribute beaker bleach formencode mongokit pymongo psycopg2 sqlalchemy \
waitress cryptacular gunicorn pyramid pyramid_beaker pyramid_debugtoolbar \
pyramid_simpleform pyramid_tm python-ldap webhelpers lxml nose nose-cov \
nose-progressive rednose nose_fixes argparse python-magic httplib2 pyyaml pillow
csvkit beautifulsoup4 networkx pymongo gunicorn zope.sqlalchemy msgpack ujson requests[security]"

build_python() {
    wget http://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
    tar -zxvf Python-${VERSION}.tgz
    cd Python-${VERSION}/
    ./configure --prefix=${DEST}
    make -j4
    make install
}

clean_python() {
    sudo rm -rf ${DEST}/*
    rm -rf Python-${VERSION}
}

install_the_installer() {
    curl http://python-distribute.org/distribute_setup.py | ${DEST}/bin/python3.6
}

install_deps() {
    sudo aptitude install build-essential devscripts \
        postgresql-server-dev-9.1 libldap2-dev libxslt-dev libxml2-dev \
        libjpeg-dev libfreetype6-dev liblcms2-dev libyaml-dev libncurses5-dev
}

setup_base() {
    sudo mkdir -p $DEST
    sudo chown ${USER}. $DEST
}

install_the_pkgs() {
	${DEST}/bin/pip3 install --upgrade pip
	for pkg in $PKGS ; do
        ${DEST}/bin/pip3 install $pkg
    done
}

upgrade_the_pkgs() {
    for pkg in $PKGS ; do
        ${DEST}/bin/pip3 install --upgrade $pkg
    done
}

build_the_pkg() {
    dch +i
    debuild --no-lintian -uc -us -b 
}

usage() {

cat <<EOF

    One of: 
     - build: remove the existing build env (if exists) and build a new
     python and distribute / pip base.

     - clean: remove the existing build env (if exists) and the local
     instance of the Python tarball

     - install: install the pkgs

     - upgrade: upgrade the pkgs

     - pkg: build the debian pkg

EOF
}
case $1 in

  "build")
    install_deps
    setup_base
    build_python
    install_the_installer
    ;;

  "clean")
    setup_base
    clean_python
    ;;

  "install")
    install_the_pkgs
    ;;

  "upgrade")
    upgrade_the_pkgs
    ;;

  "pkg")
    build_the_pkg
    ;;

  *)
    usage
    ;;

esac
