#!/usr/bin/env nix-shell
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

def sign_message(message):
    # Create a temporary file for the message
    with tempfile.NamedTemporaryFile(delete=False, mode='w') as message_file:
        message_file.write(message)
        message_file_name = message_file.name
    
    try:
        # Sign the message
        sign_command = ["gpg", "--clearsign", message_file_name]
        result = subprocess.run(sign_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        # Read the signed message
        with open(f"{message_file_name}.asc", 'r') as signed_file:
            signed_message = signed_file.read()
        
        print("Message signed successfully.")
        print("Clearsigned message:")
        print(signed_message)
        
        return signed_message
    except subprocess.CalledProcessError as e:
        print("Message signing failed:", e.stderr.decode())
    finally:
        # Clean up temporary files
        try:
            os.remove(message_file_name)
            os.remove(f"{message_file_name}.asc")
        except OSError as e:
            print(f"Error cleaning up temporary files: {e.strerror}")

if __name__ == "__main__":
    print("Please enter the message to sign, then press Ctrl+D when done:")
    message = get_multiline_input("")

    sign_message(message)
