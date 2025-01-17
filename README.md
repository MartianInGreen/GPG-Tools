# GPG Utilities

This project provides a set of scripts for signing, encrypting, and verifying files using GPG (GNU Privacy Guard). It includes both Python and Bash scripts to facilitate various cryptographic operations.

## Features

- **Sign Messages**: Clearsign or detach-sign messages using GPG.
- **Symmetric Encryption**: Encrypt and decrypt files using a password.
- **Asymmetric Encryption**: Encrypt and decrypt files using recipient keys.
- **Verify Signatures**: Verify signed messages and files.

## Scripts

### Python Scripts

1. **gpg-clearsign-cmd.zsh**: 
   - Prompts for a message and signs it using GPG.
   - Requires GPG installed and configured.

2. **gpg-verify-clearsign.zsh**: 
   - Verifies a signed message using a public key.

### Bash Scripts

1. **gpg-crypt-sym.zsh**: 
   - Symmetrically encrypts or decrypts a file.
   - Usage: `gpg-crypt-sym.zsh -f <file> -o <output> -m <mode> [-p password] [-a]`

2. **gpg-crypt.zsh**: 
   - Asymmetrically encrypts or decrypts a file.
   - Usage: `gpg-crypt.zsh -f <file> -o <output> -r <recipient> -m <mode> [-a]`

3. **gpg-sign-file.zsh**: 
   - Signs a file using a specified GPG key.
   - Usage: `gpg-sign-file.zsh -f <file> -o <output> -k <key> -s <signing_option>`

4. **gpg-verify-file.zsh**: 
   - Verifies a file against its signature.
   - Usage: `gpg-verify-file.zsh -f <file> -s <signature>`

## Requirements

- GPG installed on your system.
- Nix package Manager (for Python scripts)

## License

MIT License. See [LICENSE](LICENSE) for details.

## Usage

Refer to the usage instructions in each script for specific command-line options and examples.
