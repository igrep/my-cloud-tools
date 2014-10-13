/*
Utilities I need to manage my server instance on Sakura Cloud.
Not for general purpose: I ommit most of entities documented on http://developer.sakura.ad.jp/cloud/api/1.1/
*/

package sakuraCloud

import (
	"net/http"
	"os"
	"io/ioutil"
	"strings"
)

const aPI_ROOT = "https://secure.sakura.ad.jp/cloud/zone/is1a/api/cloud/1.1/"

type Server struct {
	Id string
}
