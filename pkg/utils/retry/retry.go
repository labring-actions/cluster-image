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

package retry

import (
	"math/rand"
	"net/http"
	"time"
)

var (
	defaultSleep = 500 * time.Millisecond
)

// Func is the function to be executed and eventually retried.
type Func func() error

// HTTPFunc is the function to be executed and eventually retried.
// The only difference from Func is that it expects an *http.Response on the first returning argument.
type HTTPFunc func() (*http.Response, error)

// Do runs the passed function until the number of retries is reached.
// Whenever Func returns err it will sleep and Func will be executed again in a recursive fashion.
// The sleep value is slightly modified on every retry (exponential backoff) to prevent the thundering herd problem (https://en.wikipedia.org/wiki/Thundering_herd_problem).
// If no value is given to sleep it will defaults to 500ms.
func Do(fn Func, retries int, sleep time.Duration, thundering bool) error {
	if sleep == 0 {
		sleep = defaultSleep
	}

	if err := fn(); err != nil {
		retries--
		if retries <= 0 {
			return err
		}
		if thundering {
			// preventing thundering herd problem (https://en.wikipedia.org/wiki/Thundering_herd_problem)
			sleep += (time.Duration(rand.Int63n(int64(sleep)))) / 2
			time.Sleep(sleep)

			return Do(fn, retries, 2*sleep, thundering)
		} else {
			time.Sleep(sleep)
			return Do(fn, retries, sleep, thundering)
		}

	}

	return nil
}
