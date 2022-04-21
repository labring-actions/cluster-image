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

import (
	"github.com/labring/cluster-image/pkg/utils/logger"
)

//HW 代表华为参数
//ALI 代表阿里参数

const (
	ALIInternetChargeType      = "PayByTraffic"
	ALIInternetMaxBandwidthIn  = "100"
	ALIInternetMaxBandwidthOut = "100"
	ALIInstanceChargeType      = "PostPaid"
	ALISpotStrategy            = "SpotAsPriceGo"
)

var (
	ALIRegionId        string
	ALIZoneId          string
	ALIImageId         string
	ALIInstanceType    string
	ALISecurityGroupId string
	ALIVSwitchId       string
)

type Type string

const (
	AMD64   Type = "amd64"
	ARM64   Type = "arm64"
	GPU     Type = "gpu"
	HKAmd64 Type = "hk_amd64"
)

func shEcs(t Type) {
	ALIRegionId = "cn-shanghai"
	ALIZoneId = "cn-shanghai-l"
	ALISecurityGroupId = "sg-uf6azfd8576pan1auqbi"
	ALIVSwitchId = "vsw-uf6mhzii0frwypw7gpnly"
	switch t {
	case AMD64:
		ALIImageId = "centos_7_7_x64_20G_alibase_20211130.vhd"
		ALIInstanceType = "ecs.g7a.large" //0.130
	case ARM64:
		ALIImageId = "ubuntu_20_04_arm64_20G_alibase_20211027.vhd"
		ALIInstanceType = "ecs.g6r.large" //0.154
	case GPU:
		ALIImageId = "centos_7_7_x64_20G_alibase_20211130.vhd"
		ALIInstanceType = "ecs.gn6i-c4g1.xlarge" //1.438
	case HKAmd64:
		ALIRegionId = "cn-hongkong"
		ALIZoneId = "cn-hongkong-c"
		ALIInstanceType = "ecs.t6-c1m4.large"
		ALIImageId = "centos_7_7_x64_20G_alibase_20211130.vhd"
		ALISecurityGroupId = "sg-j6cb45dolegxcb32b47w"
		ALIVSwitchId = "vsw-j6cvaap9o5a7et8uumqyx"
	default:
		logger.Warn("not fount ecs type,so create default amd64 ecs")
		ALIImageId = "centos_7_7_x64_20G_alibase_20211130.vhd"
		ALIInstanceType = "ecs.g7a.large" //0.130
	}
}
