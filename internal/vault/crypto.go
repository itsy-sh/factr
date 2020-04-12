package vault

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"golang.org/x/crypto/chacha20poly1305"
	"golang.org/x/crypto/scrypt"
	"io"
)

type Vault struct {
	key     []byte  `json:"-"` // TODO move this elsewhere
	salt    []byte  `json:"-"`
	Entries []Entry `json:"entries"`
}





func New(passphrase string) (v *Vault, err error) {

	salt := make([]byte, 12)
	if _, err := io.ReadFull(rand.Reader, salt); err != nil {
		return nil, err
	}

	var vault Vault
	vault.salt = []byte(base64.StdEncoding.EncodeToString(salt))
	vault.key, err = scrypt.Key([]byte(passphrase), vault.salt, 32768, 8, 1, chacha20poly1305.KeySize)
	if err != nil {
		return nil, err
	}

	return &vault, nil
}

func Open(passphrase string, rawvault []byte) (v *Vault, err error) {

	rv := rawVault{}

	err = json.Unmarshal(rawvault, &rv)
	if err != nil {
		return nil, err
	}

	var vault Vault
	vault.salt = []byte(rv.Salt)
	vault.key, err = scrypt.Key([]byte(passphrase), vault.salt, 32768, 8, 1, chacha20poly1305.KeySize)
	if err != nil {
		return nil, err
	}

	sealed, err := base64.StdEncoding.DecodeString(rv.Entires)
	if err != nil {
		return
	}
	opened, err := open(vault.key, sealed)
	if err != nil {
		return nil, err
	}

	err = json.Unmarshal(opened, &vault)
	if err != nil {
		return nil, err
	}
	return &vault, nil
}

func (v *Vault) Seal() (rawvault []byte, err error) {
	opened, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	sealed, err := seal(v.key, opened)

	rw := rawVault{
		Salt:    string(v.salt),
		Entires: base64.StdEncoding.EncodeToString(sealed),
	}
	return json.Marshal(rw)
}

func open(key, sealed []byte) (plain []byte, err error) {

	ahead, err := chacha20poly1305.NewX(key)
	if err != nil {
		return nil, err
	}

	nonce := sealed[:ahead.NonceSize()]
	cipher := sealed[ahead.NonceSize():]

	plain, err = ahead.Open(nil, nonce, cipher, nil)
	if err != nil {
		return nil, err
	}
	return plain, nil
}

func seal(key, plain []byte) (sealed []byte, err error) {

	ahead, err := chacha20poly1305.NewX(key)
	if err != nil {
		return nil, err
	}

	nonce := make([]byte, ahead.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return nil, err
	}

	cipher := ahead.Seal(nil, nonce, plain, nil)
	return append(nonce, cipher...), nil
}
