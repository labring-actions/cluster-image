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

package ecs

type Cloud interface {
	New(amount int, dryRun bool, bandwidthOut bool) []string
	Delete(instanceId []string, maxCount int)
	Describe(instanceId string) (*CloudInstanceResponse, error)
	Healthy() error
}
type CloudInstanceResponse struct {
	IsOk      bool
	PrivateIP string
	PublicIP  string
}

func NewCloud(t Type) Cloud {
	var c Cloud
	c = &AliyunEcs{Type: t}
	return c
}
