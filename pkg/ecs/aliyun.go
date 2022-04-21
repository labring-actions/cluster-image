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
	"errors"
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/requests"
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/utils"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	cutils "github.com/labring/cluster-image/pkg/utils"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/labring/cluster-image/pkg/vars"
	"strconv"
	"sync"
)

func (a *AliyunEcs) getClient() *ecs.Client {
	a.ecsOnce.Do(func() {
		var err error
		a.ecsHKCli, err = ecs.NewClientWithAccessKey("", vars.Run.AkID, vars.Run.AkSK)
		if err != nil {
			_ = cutils.ProcessCloudError(err)
		}
	})
	return a.ecsHKCli
}

type AliyunEcs struct {
	ecsOnce  sync.Once
	ecsHKCli *ecs.Client
	Type     Type
}

func (a *AliyunEcs) Healthy() error {
	shEcs(a.Type)
	cli, err := ecs.NewClientWithAccessKey("", vars.Run.AkID, vars.Run.AkSK)
	if err != nil {
		return err
	}
	r := ecs.CreateDescribeZonesRequest()
	r.RegionId = ALIRegionId
	_, err = cli.DescribeZones(r)
	if err != nil {
		return errors.New("阿里云 " + err.Error())
	}
	return nil
}

func (a *AliyunEcs) New(amount int, dryRun bool, bandwidthOut bool) []string {
	client := a.getClient()
	// 创建请求并设置参数
	shEcs(a.Type)
	hk := ecs.CreateRunInstancesRequest()
	hk.ImageId = ALIImageId
	hk.InstanceType = ALIInstanceType
	hk.InternetChargeType = ALIInternetChargeType
	hk.InternetMaxBandwidthIn = ALIInternetMaxBandwidthIn
	hk.InternetMaxBandwidthOut = ALIInternetMaxBandwidthOut
	hk.InstanceChargeType = ALIInstanceChargeType
	hk.SpotStrategy = ALISpotStrategy
	hk.RegionId = ALIRegionId
	hk.SecurityGroupId = ALISecurityGroupId
	hk.VSwitchId = ALIVSwitchId
	hk.ZoneId = ALIZoneId
	hk.Password = vars.EcsPassword
	tags := []ecs.RunInstancesTag{
		{Key: "type", Value: string(a.Type)}, {Key: "runtime", Value: "sealos"},
	}
	hk.Tag = &tags
	hk.Amount = requests.Integer(strconv.Itoa(amount))
	hk.ClientToken = utils.GetUUID()
	if !bandwidthOut {
		hk.InternetMaxBandwidthOut = "0"
	}
	hk.DryRun = requests.Boolean(strconv.FormatBool(dryRun))
	response, err := client.RunInstances(hk)
	if err != nil {
		_ = cutils.ProcessCloudError(err)
		return nil
	}
	return response.InstanceIdSets.InstanceIdSet
}

func (a *AliyunEcs) Delete(instanceId []string, maxCount int) {
	client := a.getClient()
	// 创建请求并设置参数
	shEcs(a.Type)
	request := ecs.CreateDeleteInstancesRequest()
	request.DryRun = requests.Boolean(strconv.FormatBool(false))
	request.Force = "true"
	request.RegionId = ALIRegionId
	request.InstanceId = &instanceId
	var response *ecs.DeleteInstancesResponse
	var err error
	for i := 0; i < maxCount; i++ {
		logger.Info("递归删除ecs")
		response, err = client.DeleteInstances(request)
		if err != nil {
			_ = cutils.ProcessCloudError(err)
		} else {
			break
		}
	}
	if err == nil {
		logger.Info("删除ecs成功: %s", response.RequestId)
	} else {
		logger.Error("删除ecs失败: %v", instanceId)
	}
}

func (a *AliyunEcs) Describe(instanceId string) (*CloudInstanceResponse, error) {
	client := a.getClient()
	shEcs(a.Type)
	request := ecs.CreateDescribeInstanceAttributeRequest()
	request.RegionId = ALIRegionId
	request.InstanceId = instanceId
	attr, err := client.DescribeInstanceAttribute(request)
	if err != nil {
		return nil, err
	}
	iResponse := &CloudInstanceResponse{
		IsOk: attr.Status == "Running",
	}
	if len(attr.VpcAttributes.PrivateIpAddress.IpAddress) > 0 {
		iResponse.PrivateIP = attr.VpcAttributes.PrivateIpAddress.IpAddress[0]
	}
	if len(attr.PublicIpAddress.IpAddress) > 0 {
		iResponse.PublicIP = attr.PublicIpAddress.IpAddress[0]
	}
	return iResponse, nil
}
