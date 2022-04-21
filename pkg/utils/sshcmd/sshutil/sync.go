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

package sshutil

import (
	"context"
	"golang.org/x/sync/errgroup"
)

type SSHSync []SSH

func InitSSHSync(password string, hosts ...string) SSHSync {
	var sync SSHSync
	for _, host := range hosts {
		sync = append(sync, SSH{
			User:     "root",
			Password: password,
			Host:     host,
		})
	}
	return sync
}

func (s SSHSync) CMD(cmd string) error {
	eg, _ := errgroup.WithContext(context.Background())
	for _, node := range s {
		no := node
		eg.Go(func() error {
			return no.CmdAsync(cmd)
		})
	}
	return eg.Wait()
}
