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
	"fmt"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"github.com/spf13/cobra"
	"os"
)

var loggerFile string
var loggerLevel int

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "cloud-kernel",
	Short: "auto update k8s to sealyun",
	// Uncomment the following line if your bare application
	// has an action associated with it:
	//	Run: func(cmd *cobra.Command, args []string) { },
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.Flags().StringVar(&loggerFile, "logger-file", "", "输出日志的文件路径")
	rootCmd.Flags().IntVar(&loggerLevel, "logger-level", 5, "输出日志的文件级别，支持3 error, 4 warn, 5 info, 6 debug, 7 trace")
}

func initConfig() {
	logger.Cfg(loggerLevel, loggerFile)
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
