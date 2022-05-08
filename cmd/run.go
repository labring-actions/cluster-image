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

var gFetch []string

// runCmd represents the run command
var runCmd = &cobra.Command{
	Use:   "run",
	Short: "执行打包离线包并发布到镜像仓库上",
	Run: func(cmd *cobra.Command, args []string) {
		if len(gFetch) == 0 {
			logger.Warn("当月无需要更新版本")
			os.Exit(0)
		} else {
			builder := rootfs.NewBuild(gFetch)
			if err := builder.Exec(); err != nil {
				logger.Error("执行发生错误: %s", err.Error())
				os.Exit(1)
			}
			logger.Info("cluster-image build kubernetes %v success", gFetch)
		}
	},
	PreRun: func(cmd *cobra.Command, args []string) {
		logger.Debug("run param k8s-versions: %v", gFetch)
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

		if vars.Run.DingDing == "" {
			logger.Warn("钉钉的Token为空,无法自动通知")
		}

	},
}

func init() {
	rootCmd.AddCommand(runCmd)
	runCmd.Flags().StringVar(&vars.Run.AkID, "ak", "", "云厂商的 akId")
	runCmd.Flags().StringVar(&vars.Run.AkSK, "sk", "", "云厂商的 akSK")
	runCmd.Flags().StringVar(&vars.Run.DingDing, "dingding", "", "钉钉的Token")
	runCmd.Flags().StringVar(&vars.Run.RegistryDomain, "repo-domain", "registry-vpc.cn-hongkong.aliyuncs.com", "默认仓库Domain")
	runCmd.Flags().StringVar(&vars.Run.RegistryRepo, "repo", "sealyun", "默认仓库")
	runCmd.Flags().StringVar(&vars.Run.RegistryUsername, "repo-username", "sealyun@1244797166814602", "默认用户名")
	runCmd.Flags().StringVar(&vars.Run.RegistryPassword, "repo-password", "", "默认密码")

	runCmd.Flags().StringVar(&vars.Run.MarketCtlToken, "marketctl", "", "marketctl的token")
	runCmd.Flags().StringSliceVar(&gFetch, "k8s-versions", gFetch, "需要拉取的版本信息，如果为空则获取github当前一个月内有效版本")
}
