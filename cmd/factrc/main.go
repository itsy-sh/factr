package main

import (
	"fmt"
	"github.com/rygga/factr/internal/store"
	"github.com/rygga/factr/internal/vault"
)

func check (err error){
	if err != nil{
		panic(err)
	}
}

func main(){



	v, err := vault.New("qwerty")
	check(err)
	v.Entries = append(v.Entries, vault.Entry{
		Name:     "test",
		Secret:   "MySecret",
		Metadata: nil,
	})

	raw, err := v.Seal()
	check(err)

	err = store.Save(raw)
	check(err)

	raw, err = store.Load()
	check(err)

	v, err = vault.Open("qwerty", raw)
	check(err)

	fmt.Printf("%s\n", string(raw))
	fmt.Printf("%+v\n", v)

}

