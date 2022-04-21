// Copyright © 2022 sealyun.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package marketctl

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/wonderivan/logger"
	"io/ioutil"
	"net/http"
)

func Do(domain, uri, method, accessToken string, post []byte) error {
	_, err := do(domain, uri, method, accessToken, nil, post)
	return err
}
func DoBody(domain, uri, method, accessToken string, post []byte) ([]byte, error) {
	return do(domain, uri, method, accessToken, nil, post)
}
func DoBodyAddHeader(domain, uri, method, accessToken string, headers map[string]string, post []byte) ([]byte, error) {
	return do(domain, uri, method, accessToken, headers, post)
}
func do(domain, uri, method, accessToken string, headers map[string]string, post []byte) ([]byte, error) {
	req, err := http.NewRequest(method, domain+uri, bytes.NewReader(post))
	if err != nil {
		return nil, err
	}
	client := &http.Client{}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("User-agent", "MarketCtl")
	req.Header.Set("AccessToken", accessToken)
	if headers != nil {
		for k, v := range headers {
			req.Header.Set(k, v)
		}
	}
	resp, err := client.Do(req)
	if err != nil {
		//logger.Error("response error is %s", err.Error())
		return nil, err
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	if resp.StatusCode != 200 {
		logger.Error(resp.Status)
		return nil, fmt.Errorf("respone status is not correct")
	} else {
		var out map[string]interface{}
		_ = json.Unmarshal(body, &out)
		if code, ok := out["code"].(float64); ok && code != 200 {
			return nil, fmt.Errorf(out["message"].(string))
		}
	}
	return body, nil
}
