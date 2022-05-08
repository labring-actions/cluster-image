/*
Copyright 2022 cuisongliu@qq.com.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package rootfs

import (
	"errors"
	"fmt"
	"github.com/labring/cluster-image/pkg/ecs"
	"github.com/labring/cluster-image/pkg/utils"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/labring/cluster-image/pkg/utils/retry"
	"github.com/labring/cluster-image/pkg/utils/sshcmd/sshutil"
	"github.com/labring/cluster-image/pkg/vars"
	"os"
	"text/template"
	"time"
)

type Builder interface {
	Exec() error
}

type build struct {
	PublicIP     string
	Type         ecs.Type
	Instances    []string
	KubeVersions []string
	SSHClient    *sshutil.SSH
	APPType      string
	APPVersion   string
	APPDir       string
}

func NewBuild(versions []string) Builder {
	return &build{Type: ecs.HKAmd64, KubeVersions: versions}
}

func NewAppBuild(version string, appType string, appDir string) Builder {
	return &build{Type: ecs.HKAmd64, APPType: appType, APPVersion: version, APPDir: appDir}
}

func (b *build) Exec() error {
	var pipelines []func() error
	pipelines = append(pipelines, b.createPublicInstance, b.getPublicInstancePublicIP, b.pingPublicIP, b.initInstall)
	if b.APPType == "" {
		pipelines = append(pipelines, b.kubePackage)
	} else {
		pipelines = append(pipelines, b.appPackage)
	}

	pipelines = append(pipelines, b.deletePublicInstance)

	var err error
	for _, f := range pipelines {
		if err = f(); err != nil {
			logger.Error("exec pipelines error: %s , after 10s delete instance", err)
			break
		}
	}
	if err != nil {
		time.Sleep(10 * time.Second)
		logger.Info("error in daley delete instance")
		_ = b.deletePublicInstance()
	}

	return err
}

func (b *build) createPublicInstance() error {
	logger.Info("create public instance")
	b.Instances = ecs.NewCloud(b.Type).New(1, false, true)
	if b.Instances == nil {
		return errors.New("create public ecs is error")
	}
	logger.Info("instances is %v", b.Instances)
	return nil
}

func (b *build) deletePublicInstance() error {
	logger.Info("delete public instance")
	ecs.NewCloud(b.Type).Delete(b.Instances, 10)
	return nil
}

func (b *build) getPublicInstancePublicIP() error {
	logger.Info("get public instance public ip")
	var instanceInfo *ecs.CloudInstanceResponse
	if err := retry.Do(func() error {
		var err error
		instanceInfo, err = ecs.NewCloud(b.Type).Describe(b.Instances[0])
		if err != nil {
			return err
		}
		if instanceInfo.PublicIP == "" {
			return errors.New("retry get public ip empty")
		}
		if !instanceInfo.IsOk {
			return errors.New("retry ecs is not ok")
		}
		return nil
	}, 100, 1*time.Second, false); err != nil {
		return utils.ProcessError(err)
	}
	b.PublicIP = instanceInfo.PublicIP
	return nil
}

func (b *build) getSSHClient() sshutil.SSH {
	if b.SSHClient == nil {
		b.SSHClient = &sshutil.SSH{
			User:     "root",
			Password: vars.EcsPassword,
			Timeout:  nil,
			Host:     b.PublicIP,
		}
	}
	return *b.SSHClient
}

func (b *build) pingPublicIP() error {
	logger.Info("ping public ip: %s", b.PublicIP)
	publicIP := b.PublicIP
	client := b.getSSHClient()
	if err := retry.Do(func() error {
		var err error
		logger.Debug("retry ping ecs ssh: " + publicIP)
		_, err = client.CmdAndError("ls")
		if err != nil {
			return err
		} else {
			return nil
		}
	}, 20, 500*time.Millisecond, true); err != nil {
		return utils.ProcessError(err)
	}
	return nil
}

func (b *build) initInstall() error {
	logger.Info("init public instance install")
	client := b.getSSHClient()
	shell := `
yum install -y wget && \
wget https://sealyun-home.oss-cn-beijing.aliyuncs.com/images/cluster-image.tar.gz -O cluster-image.tar.gz && \
tar -zxvf cluster-image.tar.gz && cp -rf hack/* .
`
	return client.CmdAsync(shell)
}

func (b *build) kubePackage() error {
	logger.Info("build kube image")
	//sh build.sh 1.22.8 registry-vpc.cn-hongkong.aliyuncs.com sealyun sealyun@1244797166814602 xxxx
	buildFmt := "sh build.sh %s %s %s %s %s"
	client := b.getSSHClient()

	type ErrorData struct {
		Version string
		Error   string
	}
	var errs []ErrorData
	for _, version := range b.KubeVersions {
		logger.Debug("当前build版本: " + version)
		if err := client.CmdAsync(fmt.Sprintf(buildFmt, version, vars.Run.RegistryDomain, vars.Run.RegistryRepo, vars.Run.RegistryUsername, vars.Run.RegistryPassword)); err != nil {
			errs = append(errs, ErrorData{
				Version: version,
				Error:   err.Error(),
			})
		}
	}
	if len(errs) > 0 {
		t := template.New("output")
		t, err := t.Parse(
			`Version List:
    {{- range .ErrorList }}
		Version: {{ .Version }}
		Error: {{ .Error }}
    {{- end }}
`)
		if err != nil {
			panic(err)
		}
		t = template.Must(t, err)
		err = t.Execute(os.Stdout, map[string][]ErrorData{"ErrorList": errs})
		if err != nil {
			logger.Error("output template can not excute %s", err)
			return err
		}
	}

	return nil
}

func (b *build) appPackage() error {
	logger.Info("build app image")
	buildFmt := "sh application.sh %s %s %s %s %s %s %s"
	client := b.getSSHClient()

	type ErrorData struct {
		Version string
		Error   string
	}
	logger.Debug("当前build版本: " + b.APPVersion)
	return client.CmdAsync(fmt.Sprintf(buildFmt, b.APPVersion, vars.Run.RegistryDomain, vars.Run.RegistryRepo, vars.Run.RegistryUsername, vars.Run.RegistryPassword, b.APPType, b.APPDir))
}
