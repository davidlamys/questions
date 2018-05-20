#!/bin/bash

cd $(git rev-parse --show-toplevel)
. scripts/display.script

testCommand () {
	if  ! [ -x "$(command -v $1)" ]; then
		error $1" needs to be installed"
		exit 99
	else
		header $1
		info "path:"
        command which $1
		info "version:"
        command $1 $2
		info ""
	fi
}

testCommand git --version
testCommand gcc --version
testCommand xcode-select --version
testCommand swift --version
testCommand carthage version
testCommand rome --version
testCommand swiftgen --version
testCommand swiftlint version
testCommand synx --version
