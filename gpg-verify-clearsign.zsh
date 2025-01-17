#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python312

import subprocess
import tempfile
import sys
import os

def get_multiline_input(prompt):
    print(prompt)
    lines = []
    while True:
        try:
            line = input()
            lines.append(line)
        except EOFError:
            break
    return "\n".join(lines)

def verify_pgp_signature(signed_message, public_key):
    # Create temporary files for the signed message and the public key
    with tempfile.NamedTemporaryFile(delete=False, mode='w') as signed_message_file:
        signed_message_file.write(signed_message)
        signed_message_file_name = signed_message_file.name
    
    with tempfile.NamedTemporaryFile(delete=False, mode='w') as public_key_file:
        public_key_file.write(public_key)
        public_key_file_name = public_key_file.name
    
    try:
        # Import the public key
        import_command = ["gpg", "--import", public_key_file_name]
        subprocess.run(import_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print("Public key imported successfully.")
        
        # Verify the signature
        verify_command = ["gpg", "--verify", signed_message_file_name]
        result = subprocess.run(verify_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(result.stderr.decode())
        print("Signature verified successfully.")
    except subprocess.CalledProcessError as e:
        print("Signature verification failed:", e.stderr.decode())
    finally:
        # Clean up temporary files
        try:
            os.remove(signed_message_file_name)
            os.remove(public_key_file_name)
        except OSError as e:
            print(f"Error cleaning up temporary files: {e.strerror}")

if __name__ == "__main__":
    print("Please paste the signed message block, then press Ctrl+D when done:")
    signed_message = get_multiline_input("")

    print("Please paste the public key block, then press Ctrl+D when done:")
    public_key = get_multiline_input("")

    verify_pgp_signature(signed_message, public_key)
