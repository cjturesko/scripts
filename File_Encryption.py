from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import secrets


def generate_key():
    key = AESGCM.generate_key(bit_length=256)
    with open("aesgcm_key.key", "wb") as key_file:
        key_file.write(key)
    return key


def load_key():
    return open("aesgcm_key.key", "rb").read()


def encrypt_file(file_path):
    key = load_key()  # Load the AES-GCM key
    nonce = secrets.token_bytes(12)  # Generate a random 12-byte nonce using secrets
    aesgcm = AESGCM(key)

    with open(file_path, "rb") as file:
        original_data = file.read()

    encrypted_data = aesgcm.encrypt(nonce, original_data, None)

    with open(file_path + ".aesgcm", "wb") as encrypted_file:
        # Write the nonce at the beginning of the file, needed for decryption
        encrypted_file.write(nonce + encrypted_data)

    print(f"File '{file_path}' encrypted successfully.")


def decrypt_file(encrypted_file_path):
    key = load_key()  # Load the AES-GCM key

    with open(encrypted_file_path, "rb") as encrypted_file:
        nonce = encrypted_file.read(12)  # Read the nonce (first 12 bytes)
        encrypted_data = encrypted_file.read()

    aesgcm = AESGCM(key)
    decrypted_data = aesgcm.decrypt(nonce, encrypted_data, None)

    decrypted_file_path = encrypted_file_path.replace("_decrypted.aesgcm")
    with open(decrypted_file_path, "wb") as decrypted_file:
        decrypted_file.write(decrypted_data)

    print(f"File '{encrypted_file_path}' decrypted successfully.")


if __name__ == "__main__":
    # Generate a key (Run this only once and keep the key safe!)
    #generate_key()

    # Example usage:
    file_to_encrypt = "CW.mkv"

    # Encrypt the file
    encrypt_file(file_to_encrypt)

    # Decrypt the file
    decrypt_file(file_to_encrypt + ".aesgcm")
