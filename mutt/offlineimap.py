import keyring

def get_mutt_password(account):
    return keyring.get_password('mutt', account)
