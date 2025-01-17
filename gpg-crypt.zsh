#!/usr/bin/env bash

# Parse arguments
while getopts "f:o:r:m:ah" opt; do
    case $opt in
        f)
            file=$OPTARG
            ;;
        o)
            output=$OPTARG
            ;;
        r)
            recipient=$OPTARG
            ;;
        m)
            mode=$OPTARG
            ;;
        a)
            armor=true
            ;;
        h)
            echo "Usage: gpg-crypt.zsh -f <file> -o <output> -r <recipient> -m <mode> [-a]"
            echo "-f: The file to encrypt/decrypt"
            echo "-o: The output file"
            echo "-r: The recipient's email or key ID (for encryption)"
            echo "-m: Mode (encrypt or decrypt)"
            echo "-a: Use ASCII armor output (for encryption)"
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

# Set default output if not specified
if [ -z "$output" ]; then
    if [ "$mode" = "encrypt" ]; then
        output="$file.gpg"
    else
        output="${file%.*}"
    fi
fi

# Handle encryption/decryption
case $mode in
    encrypt)
        if [ -z "$recipient" ]; then
            gpg --list-keys
            echo "Please enter the recipient's email or key ID:"
            read recipient
        fi
        
        if [ "$armor" = true ]; then
            gpg --armor --encrypt \
                --recipient "$recipient" \
                --output "$output" \
                "$file"
        else
            gpg --encrypt \
                --recipient "$recipient" \
                --output "$output" \
                "$file"
        fi
        ;;
    decrypt)
        gpg --decrypt \
            --output "$output" \
            "$file"
        ;;
    *)
        echo "Invalid mode. Use 'encrypt' or 'decrypt'"
        exit 1
        ;;
esac

# Check if operation was successful
if [ $? -eq 0 ]; then
    echo "Operation completed successfully"
    echo "Output saved to: $output"
else
    echo "Operation failed"
    exit 1
fi