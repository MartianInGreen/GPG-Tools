#!/usr/bin/env bash

# Veryify a file using GPG
# Usage: gpg-verify-file.zsh -f <file> -s <signature>
# -f: The file to verify
# -s: The signature file

# Parse arguments
while getopts "f:s:h" opt; do
    case $opt in
        f)
            file=$OPTARG
            ;;
        s)
            signature=$OPTARG
            ;;
        h)
            echo "Usage: gpg-verify-file.zsh -f <file> -s <signature>"
            echo "-f: The file to verify"
            echo "-s: The signature file"
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi

# Check if the signature file exists
if [ ! -f "$signature" ]; then
    echo "Signature file not found: $signature"
    exit 1
fi

# Verify the file
gpg --verify "$signature" "$file"