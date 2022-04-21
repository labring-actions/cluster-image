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
	"fmt"
	"github.com/labring/cluster-image/pkg/vars"
)

const DefaultDomain = "https://www.sealyun.com"
const DefaultTestDomain = "https://market.cuisongliu.com"

func Healthy(release bool) error {
	uri := fmt.Sprintf("/api/v2/healthy")
	return Do(Domain(release), uri, "GET", vars.Run.MarketCtlToken, nil)
}

func Domain(release bool) string {
	domain := DefaultDomain
	if !release {
		domain = DefaultTestDomain
	}
	return domain
}
