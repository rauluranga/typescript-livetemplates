#!/bin/sh

	# Fail fast if we're not on OS X.

	if [ "$(uname -s)" != "Darwin" ]; then
		echo "Sorry, Mac OS X is needed to run." >&2
		exit 1
	fi

	logging() {
	    # write your test however you want; this just tests if SILENT is non-empty
	    if [ -n "$SILENT" ]; then
	        "$@" &> /dev/null
	    else
	        "$@"
	    fi
	}

	# Test whether a command exists
	# $1 - cmd to test
	type_exists() {
    	if [ $(type -P $1) ]; then
      		return 0
	    fi
    	return 1
	}

	# Warning logging
	e_warning() {
	    logging printf "$(tput setaf 3)⚠ Warning:$(tput sgr0) %s!\n" "$@"
	}

	export TSLT_ROOT="${HOME}/.typescript-livetemplates"
	export GITHUB_USER="rauluranga"
	export WS_VERSION="10"

	if [[ ! -d "${TSLT_ROOT}" ]]; then

	    # no bash directory found
	    printf "$(tput bold ; tput setaf 3)⚠ Warning: $(tput sgr0)%s!\n" "No ${TSLT_ROOT} found"

	    # create directory
	    printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\n" "Creating directory at ${TSLT_ROOT}"
	    mkdir -p "${TSLT_ROOT}"

	    # Download the repository as a tarball
	    printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\n" "Downloading repository to /tmp directory"
	    curl -#fLo /tmp/typescript-livetemplates.tar.gz "https://github.com/${GITHUB_USER}/typescript-livetemplates/tarball/master"

	    # Extract to the typescript-livetemplates directory
	    printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\n" "Extracting files to ${TSLT_ROOT}"
	    tar -zxf /tmp/typescript-livetemplates.tar.gz --strip-components 1 -C "${TSLT_ROOT}"

	    # Remove the tarball
	    printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\n" "Removing tarball from /tmp directory"
	    rm -rf /tmp/typescript-livetemplates.tar.gz

	    printf "$(tput setaf 2)✓ Success: $(tput sgr0)%s.\n" "${TSLT_ROOT} created, repository downloaded and extracted"
	fi

	cd "${TSLT_ROOT}"

	printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\n" "Installing TypeScript Live Templates..."	

	cp -fr ./TypeScript.xml "${HOME}/Library/Preferences/WebStorm${WS_VERSION}/templates"

	e_warning "Restart WebStorm Application to see your newly Live Templates."

	if type_exists 'figlet' && type_exists 'cowsay' && type_exists 'toilet'; then
		figlet -k 'Enjoy!' | cowsay -f moose -n | toilet --gay -f term   
	fi

	cd "${HOME}"
	rm -rf "${TSLT_ROOT}"
