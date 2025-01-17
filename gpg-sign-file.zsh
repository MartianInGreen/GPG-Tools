#!/usr/bin/env bash

# Sign a file using GPG
# Usage: sign-file.zsh -f <file> -o <output> -k <key>
# -f: The file to sign
# -o: The output file / When left blank, the signed file will be saved as <file>.sig
# -k: The key (keyID) to use for signing / When left blank, all keys will be listed and you will be prompted to choose one
# -s: Signing option, either clearsign or detach-sign

# Parse arguments
while getopts "f:o:k:s:h" opt; do
    case $opt in
        f)
            file=$OPTARG
            ;;
        o)
            output=$OPTARG
            ;;
        k)
            key=$OPTARG
            ;;
        s)
            sign=$OPTARG
            ;;
        h)
            echo "Usage: sign-file.zsh -f <file> -o <output> -k <key>"
            echo "-f: The file to sign"
            echo "-o: The output file / When left blank, the signed file will be saved as <file>.sig"
            echo "-k: The key (keyID) to use for signing / When left blank, all keys will be listed and you will be prompted to choose one"
            echo "-s: Signing option, either clearsign or detach-sign"
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

# List keys if no key is provided
if [ -z "$key" ]; then
    gpg --list-secret-keys
    echo "Please enter the key to use for signing:"
    read key
fi

# Set the output file
if [ -z "$output" ]; then
    output="$file.sig"
fi

# Set the sign option
if [ -z "$sign" ]; then
    sign="detach-sign"
fi

# Perform the signing
if [ "$sign" = "clearsign" ]; then
    # Clear-sign the file (includes file contents in output)
    gpg --clearsign \
        --local-user "$key" \
        --output "$output" \
        "$file"
else
    # Create detached signature (default)
    gpg --detach-sign \
        --local-user "$key" \
        --output "$output" \
        "$file"
fi

# Check if signing was successful
if [ $? -eq 0 ]; then
    echo "File signed successfully"
    echo "Signature saved to: $output"
else
    echo "Signing failed"
    exit 1
fi
