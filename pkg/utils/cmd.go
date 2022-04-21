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
	"bufio"
	"fmt"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"os"
	"os/exec"
	"strings"
)

func Cmd(name string, args ...string) error {
	cmd := exec.Command(name, args[:]...) // #nosec
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	return cmd.Run()
}

func Output(name string, args ...string) ([]byte, error) {
	cmd := exec.Command(name, args[:]...) // #nosec
	return cmd.CombinedOutput()
}

func RunSimpleCmd(cmd string) (string, error) {
	result, err := exec.Command("/bin/sh", "-c", cmd).CombinedOutput() // #nosec
	return string(result), err
}

func RunBashCmd(cmd string) (string, error) {
	result, err := exec.Command("/bin/bash", "-c", cmd).CombinedOutput() // #nosec
	return string(result), err
}

func ExecForPipe(output bool, exe string, args ...string) error {
	cmdDbg := []string{exe}
	cmdDbg = append(cmdDbg, args...)
	if output {
		logger.Info("执行命令是: %s", strings.Join(cmdDbg, " "))
	}
	cmd := exec.Command(exe, args...)
	outReader, err := cmd.StdoutPipe()
	if err != nil {
		return fmt.Errorf("error creating StdoutPipe for cmd: #%v", err)
	}

	errReader, err := cmd.StderrPipe()
	if err != nil {
		return fmt.Errorf("error creating StderrPipe for cmd: #%v", err)
	}

	outScanner := bufio.NewScanner(outReader)
	go func() {
		for outScanner.Scan() {
			logger.Debug(outScanner.Text())
		}
	}()

	errScanner := bufio.NewScanner(errReader)
	go func() {
		for errScanner.Scan() {
			logger.Debug(errScanner.Text())
		}
	}()

	if err = cmd.Start(); err != nil {
		return fmt.Errorf("error starting cmd: #%v", err)
	}

	if err = cmd.Wait(); err != nil {
		return fmt.Errorf("error waiting for cmd: #%v", err)
	}

	return nil
}

func RunBashCmdForPipe(cmd string) error {
	return ExecForPipe(true, "/bin/bash", "-c", cmd)
}

func RunBashCmdForPipeNoDebug(cmd string) error {
	return ExecForPipe(false, "/bin/bash", "-c", cmd)
}

func CheckCmdIsExist(cmd string) (string, bool) {
	cmd = fmt.Sprintf("type %s", cmd)
	out, err := RunSimpleCmd(cmd)
	if err != nil {
		return "", false
	}

	outSlice := strings.Split(out, "is")
	last := outSlice[len(outSlice)-1]

	if last != "" && !strings.Contains(last, "not found") {
		return strings.TrimSpace(last), true
	}
	return "", false
}
