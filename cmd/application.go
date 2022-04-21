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

package cmd

import (
	"github.com/labring/cluster-image/pkg/ecs"
	"github.com/labring/cluster-image/pkg/rootfs"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/labring/cluster-image/pkg/vars"
	"github.com/spf13/cobra"
	"os"
)

var applicationVersion string
var applicationType string
var applicationCmd = &cobra.Command{
	Use:   "application",
	Short: "执行打包APP离线包并发布到镜像仓库上",
	Run: func(cmd *cobra.Command, args []string) {
		builder := rootfs.NewAppBuild(applicationVersion, applicationType)
		if err := builder.Exec(); err != nil {
			logger.Error("执行发生错误: %s", err.Error())
			os.Exit(1)
		}
	},
	PreRun: func(cmd *cobra.Command, args []string) {
		logger.Debug("run param arm64: %v", vars.Run.IsArm64)
		logger.Debug("run param versions: %v", applicationVersion)
		vars.LoadAKSK()
		if vars.Run.AkID == "" {
			logger.Fatal("云厂商的akId为空,无法创建ecs")
			cmd.Help()
			os.Exit(-1)
		}
		if vars.Run.AkSK == "" {
			logger.Fatal("云厂商的akSK为空,无法创建ecs")
			cmd.Help()
			os.Exit(0)
		}

		cloud := ecs.NewCloud(ecs.HKAmd64)
		if err := cloud.Healthy(); err != nil {
			logger.Fatal("云厂商的AKSK验证失败: " + err.Error())
			cmd.Help()
			os.Exit(0)
		}
	},
}

func init() {
	rootCmd.AddCommand(applicationCmd)
	applicationCmd.Flags().StringVar(&vars.Run.AkID, "ak", "", "云厂商的 akId")
	applicationCmd.Flags().StringVar(&vars.Run.AkSK, "sk", "", "云厂商的 akSK")
	applicationCmd.Flags().BoolVar(&vars.Run.IsArm64, "arm64", false, "是否为arm64")

	applicationCmd.Flags().StringVar(&vars.Run.RegistryRepo, "repo", "sealyun", "默认仓库")
	applicationCmd.Flags().StringVar(&vars.Run.RegistryUsername, "repo-username", "sealyun@1244797166814602", "默认用户名")
	applicationCmd.Flags().StringVar(&vars.Run.RegistryPassword, "repo-password", "", "默认密码")
	applicationCmd.Flags().StringVar(&applicationType, "type", "calico", "镜像类型")
	applicationCmd.Flags().StringVar(&applicationVersion, "version", "v3.22.1", "镜像版本信息")
}
