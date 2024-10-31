package main

import (
	"os/exec"
)

func main() {
	cmd := exec.Command("tmux", "popup")
	err := cmd.Run()
	if err != nil {
		panic(err)
	}
}
