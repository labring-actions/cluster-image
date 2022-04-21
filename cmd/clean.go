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
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/labring/cluster-image/pkg/vars"
	"os"

	"github.com/spf13/cobra"
)

var instanceIds []string
var t string

// cleanCmd represents the clean command
var cleanCmd = &cobra.Command{
	Use:   "clean",
	Short: "删除已经创建的ecs",
	Run: func(cmd *cobra.Command, args []string) {
		cloud := ecs.NewCloud(ecs.Type(t))
		cloud.Delete(instanceIds, 10)
	},
	PreRun: func(cmd *cobra.Command, args []string) {
		vars.LoadAKSK()
		if vars.Run.AkID == "" {
			logger.Fatal("云厂商的akId为空,无法清空虚拟机")
			cmd.Help()
			os.Exit(-1)
		}
		if vars.Run.AkSK == "" {
			logger.Fatal("云厂商的akSK为空,无法清空虚拟机")
			_ = cmd.Help()
			os.Exit(0)
		}
		cloud := ecs.NewCloud(ecs.Type(t))
		if err := cloud.Healthy(); err != nil {
			logger.Fatal("云厂商的AKSK验证失败: " + err.Error())
			cmd.Help()
			os.Exit(0)
		}
		if len(instanceIds) == 0 {
			logger.Fatal("instance id为空,无法清空虚拟机")
			cmd.Help()
			os.Exit(0)
		}
	},
}

func init() {
	rootCmd.AddCommand(cleanCmd)

	// Here you will define your flags and configuration settings.
	cleanCmd.Flags().StringVar(&vars.Run.AkID, "akid", "", "云厂商的 akId")
	cleanCmd.Flags().StringVar(&vars.Run.AkSK, "aksk", "", "云厂商的 akSK")
	cleanCmd.Flags().StringVar(&t, "type", string(ecs.AMD64), "云厂商的类型，可选值 amd64,arm64,gpu,hk_amd64")

	cleanCmd.Flags().StringSliceVar(&instanceIds, "instance", []string{}, "删除ecs的instanceID")

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// cleanCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// cleanCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
