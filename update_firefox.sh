#!/bin/bash
# (C) 2012 Ian Cordasco
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
# derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

DEBUG=${DEBUG:-/bin/false}
ARCH="$( uname -m )"
BIN_DIR=${BIN_DIR:-/usr/bin}
NAME="$(basename $0)"

if [ $( id -u ) -ne 0 ] ; then
	echo -e "*** Error: $NAME must be run as root.***" > /dev/stderr
	exit 1
fi

if [[ -z "$1" ]] ; then
	echo -e "*** Error: Must supply an argument.***" > /dev/stderr
	echo -e "Usage: $NAME firefox-version" > /dev/stderr
	exit 1
fi

if $DEBUG ; then
	debug=echo
else
	debug=""
fi

case $ARCH in
	"x86_64" )
		LIB_DIR=/usr/lib64
		;;
	"i?86" | * )
		LIB_DIR=/usr/lib
		;;
esac

OLD_DIR="$(ls -f -d $LIB_DIR/firefox*)"
INSTALL_DIR=${INSTALL_DIR:-"$LIB_DIR/$1"}
TAR_FILE=${TAR_FILE:-"$1.tar.bz2"}

$debug tar xjf $TAR_FILE
$debug mv firefox/ $INSTALL_DIR
$debug mv ${OLD_DIR}"/plugins" ${INSTALL_DIR}/
($debug cd $BIN_DIR
$debug rm firefox
$debug ln -s $INSTALL_DIR/firefox firefox)
echo -n "Remove old Firefox directory? [y/N] "
read input
[[ $input == "y" ]] && $debug rm -rf $OLD_DIR

echo "Installation Complete."
