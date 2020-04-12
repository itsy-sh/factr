package store

import (
	"io/ioutil"
	"os"
	"path/filepath"
)


func Dir() string{
	return filepath.Join(globalSettingFolder, "factr")
}

func Path() string{
	return filepath.Join(Dir(), "vault")
}



func Load() ([]byte, error){
	return ioutil.ReadFile(Path())
}

func Save(data []byte) error {

	err := os.MkdirAll(Dir(), 0775)
	if err != nil{
		return err
	}

	return ioutil.WriteFile(Path(), data, 0600)
}