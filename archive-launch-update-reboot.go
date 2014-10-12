package main

import (
	"fmt"
	"net/http"
	"os"
	"flag"
	"io/ioutil"
	"strings"
)

type Settings struct {
	AccessToken *string
	AccessTokenSecret *string
	ServerId *string
}

const API_ROOT = "https://secure.sakura.ad.jp/cloud/zone/is1a/api/cloud/1.1/"

func main() {
	s := parseSettings()

	cli := http.DefaultClient
	req, err := http.NewRequest(
		"GET",
		API_ROOT + "server/" + *s.ServerId,
		strings.NewReader(""),
	)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	req.SetBasicAuth(*s.AccessToken, *s.AccessTokenSecret)

	req.Header.Add("X-Sakura-API-Beautify", "1")

	resp, err := cli.Do(req)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer resp.Body.Close()

	fmt.Println(resp.Status)

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(string(body))

}

func parseSettings() *Settings {
	s := Settings{}

	s.AccessToken       = flag.String("access-token"       , "", "Access Token for Sakura Cloud API")
	s.AccessTokenSecret = flag.String("access-token-secret", "", "Access Token Secret for Sakura Cloud API")

	s.ServerId = flag.String("server-id", "", "Server ID on Sakura Cloud")

	flag.Parse()
	return &s
}
