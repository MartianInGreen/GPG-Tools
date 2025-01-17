#!/usr/bin/env bash

while getopts "f:o:m:p:ah" opt; do
    case $opt in
        f) file=$OPTARG ;;
        o) output=$OPTARG ;;
        m) mode=$OPTARG ;;
        p) password=$OPTARG ;;
        a) armor=true ;;
        h)
            echo "Usage: gpg-crypt-sym.zsh -f <file> -o <output> -m <mode> [-p password] [-a]"
            echo "-f: The file to encrypt/decrypt"
            echo "-o: The output file (optional)"
            echo "-m: Mode (encrypt/decrypt)"
            echo "-p: Password (optional, will prompt if not provided)"
            echo "-a: Use ASCII armor (for encryption)"
            exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    esac
done

# Validate inputs
if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi

if [[ ! "$mode" =~ ^(encrypt|decrypt)$ ]]; then
    echo "Mode must be 'encrypt' or 'decrypt'"
    exit 1
fi

# Set default output name
if [ -z "$output" ]; then
    if [ "$mode" = "encrypt" ]; then
        output="$file.gpg"
    else
        output="${file%.*}"
    fi
fi

# Build GPG command
if [ "$mode" = "encrypt" ]; then
    if [ "$armor" = true ]; then
        gpg --symmetric --armor \
            ${password:+--passphrase "$password"} \
            --output "$output" \
            "$file"
    else
        gpg --symmetric \
            ${password:+--passphrase "$password"} \
            --output "$output" \
            "$file"
    fi
else
    gpg --decrypt \
        ${password:+--passphrase "$password"} \
        --output "$output" \
        "$file"
fi

if [ $? -eq 0 ]; then
    echo "Operation completed successfully"
    echo "Output saved to: $output"
else
    echo "Operation failed"
    exit 1
fi