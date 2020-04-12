package vault

type rawVault struct {
	Salt    string `json:"salt"`
	Entires string `json:"entires"`
}

type Entry struct {
	Name     string            `json:"name"`
	Secret   string            `json:"secret"`
	Metadata map[string]string `json:"-"`
}
