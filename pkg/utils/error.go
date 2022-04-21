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

package utils

import (
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/errors"
	"github.com/labring/cluster-image/pkg/dingding"
	"github.com/labring/cluster-image/pkg/utils/logger"
)

func ProcessError(err error) error {
	//_ = os.Stderr.Close()
	//os.Exit(0)
	logger.Error(err.Error())
	return err
}

func ProcessCloudError(err error) error {
	switch err.(type) {
	case *errors.ServerError:
		e := err.(*errors.ServerError)
		logger.Error("SDK.ServerError")
		logger.Error("ErrorCode: ", e.ErrorCode())
		logger.Error("Recommend: ", e.Recommend())
		logger.Error("RequestId: ", e.RequestId())
		logger.Error("Message: ", e.Message())
		dingding.DingdingLink("离线包打包失败", "错误码:"+e.ErrorCode()+",详细信息: "+e.Message(), e.Recommend(), false)
	case *errors.ClientError:
		e := err.(*errors.ClientError)
		logger.Error("SDK.ClientError")
		logger.Error("ErrorCode: ", e.ErrorCode())
		logger.Error("Message: ", e.Message())
		dingding.DingdingText("离线包打包失败,错误码:"+e.ErrorCode()+",详细信息: "+e.Message(), false)
	default:
		logger.Error(err.Error())
		dingding.DingdingText("离线包打包失败,详细信息: "+err.Error(), false)
	}
	//_ = os.Stderr.Close()
	//os.Exit(0)
	return err
}
