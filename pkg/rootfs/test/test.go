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

package test

import (
	"errors"
	"fmt"
	"github.com/labring/cluster-image/pkg/ecs"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/labring/cluster-image/pkg/utils/retry"
	"github.com/labring/cluster-image/pkg/utils/sshcmd/sshutil"
	"github.com/labring/cluster-image/pkg/vars"
	"strings"
	"time"
)

func InstallK8s(url, flag string, t ecs.Type) error {
	cloud := ecs.NewCloud(t)
	master0 := cloud.New(1, false, true)
	others := cloud.New(3, false, false)
	instance := append(master0, others...)
	instanceInfos := make([]*ecs.CloudInstanceResponse, len(instance))
	logger.Info("test. begin create ecs")
	defer func() {
		cloud.Delete(instance, 10)
	}()

	var err error
	if err = retry.Do(func() error {
		var err error
		logger.Debug("test. retry fetch ecs info " + strings.Join(instance, ","))
		for i, v := range instance {
			instanceInfos[i], err = cloud.Describe(v)
			if err != nil {
				return err
			}
			if i == 0 {
				if instanceInfos[i].PublicIP == "" {
					return errors.New("retry error")
				}
			}
			if instanceInfos[i].PrivateIP == "" {
				return errors.New("retry error")
			}
			if !instanceInfos[i].IsOk {
				return errors.New("retry error")
			}
		}
		return nil
	}, 100, 1*time.Second, false); err != nil {
		return err
	}
	privateIPs := make([]string, len(instanceInfos))
	for i, v := range instanceInfos {
		privateIPs[i] = v.PrivateIP
	}
	master0IP := instanceInfos[0].PublicIP
	s := sshutil.SSH{
		User:     "root",
		Password: vars.EcsPassword,
		Timeout:  nil,
		Host:     master0IP,
		Debug:    true,
	}
	logger.Info("master0IP: %s", master0IP)
	logger.Info("node1IP: %s", privateIPs[1])
	logger.Info("node2IP: %s", privateIPs[2])
	logger.Info("node3IP: %s", privateIPs[3])
	logger.Debug("test. connect ssh ")
	if err = retry.Do(func() error {
		logger.Debug("test. retry test ecs  ssh ")
		ping := s.Ping()
		if ping != nil {
			logger.Warn(ping.Error())
			return ping
		}
		//sshcmd := s.CmdAsync(vars.Bin.SSHCmd.Shell())
		//if sshcmd != nil {
		//	return sshcmd
		//}
		//lsCMD := s.CmdAsync(sshcmdConnURL([]string{privateIPs[0], privateIPs[1], privateIPs[2], privateIPs[3]}))
		//if sshcmd != nil {
		//	return lsCMD
		//}
		//sealosCMD := s.CmdAsync(sealosInstallURL(flag))
		//if sealosCMD != nil {
		//	return sealosCMD
		//}
		return nil
	}, 100, 500*time.Millisecond, true); err != nil {
		return err
	}
	logger.Debug("test. install  k8s ( 3 master 1 node ) ")
	//err = s.CmdAsync(k8sInstallURL([]string{privateIPs[0], privateIPs[1], privateIPs[2], privateIPs[3]}, url))
	//if err != nil {
	//	return err
	//}
	return nil
}

func sshcmdConnURL(privateIPs []string) string {
	cmd := "sshcmd --user root --passwd %s --host %s --host %s --host %s --host %s --cmd \"ls -l\""
	connShell := fmt.Sprintf(cmd, vars.EcsPassword, privateIPs[0], privateIPs[1], privateIPs[2], privateIPs[3])

	return connShell
}

func k8sInstallURL(privateIPs []string, url string) string {
	cmd := "sealos init --master %s --master %s --master %s --node %s --passwd %s  --pkg-url %s"
	installCmd := fmt.Sprintf(cmd, privateIPs[0], privateIPs[1], privateIPs[2], privateIPs[3], vars.EcsPassword, url)

	return installCmd
}
