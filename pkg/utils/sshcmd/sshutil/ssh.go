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

package sshutil

import (
	"bufio"
	"fmt"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"io"
	"strings"
)

//Cmd is in host exec cmd
func (ss *SSH) Cmd(cmd string) []byte {
	logger.Info("[ssh][%s] %s", ss.Host, cmd)
	session, err := ss.Connect(ss.Host)
	defer func() {
		if r := recover(); r != nil {
			logger.Error("[ssh][%s]Error create ssh session failed,%s", ss.Host, err)
		}
	}()
	if err != nil {
		panic(1)
	}
	defer session.Close()
	b, err := session.CombinedOutput(cmd)
	if ss.Debug {
		logger.Debug("[ssh][%s]command result is: %s", ss.Host, string(b))
	}
	defer func() {
		if r := recover(); r != nil {
			logger.Error("[ssh][%s]Error exec command failed: %s", ss.Host, err)
		}
	}()
	if err != nil {
		panic(1)
	}
	return b
}

func (ss *SSH) CmdAndError(cmd string) ([]byte, error) {
	logger.Debug("[ssh][%s] %s", ss.Host, cmd)
	session, err := ss.Connect(ss.Host)
	if err != nil {
		return nil, err
	}
	defer session.Close()
	b, err := session.CombinedOutput(cmd)
	if ss.Debug {
		logger.Debug("[ssh][%s]command result is: %s", ss.Host, string(b))
	}
	if err != nil {
		return nil, err
	}
	return b, nil
}
func readPipe(host string, pipe io.Reader, isErr bool) {
	r := bufio.NewReader(pipe)
	for {
		line, _, err := r.ReadLine()
		if line == nil {
			return
		} else if err != nil {
			logger.Info("[%s] %s", host, line)
			logger.Error("[ssh] [%s] %s", host, err)
			return
		} else {
			if isErr {
				logger.Error("[%s] %s", host, line)
			} else {
				logger.Info(fmt.Sprintf("%s: %s", host, string(line)))
				//fmt.Println(fmt.Sprintf("%s: %s", host, string(line)))
			}
		}
	}
}

func (ss *SSH) CmdAsync(cmd string) error {
	if ss.Debug {
		logger.Debug("[%s] %s", ss.Host, cmd)
	}
	session, err := ss.Connect(ss.Host)
	if err != nil {
		logger.Error("[ssh][%s]Error create ssh session failed,%s", ss.Host, err)
		return err
	}
	defer session.Close()
	stdout, err := session.StdoutPipe()
	if err != nil {
		logger.Error("[ssh][%s]Unable to request StdoutPipe(): %s", ss.Host, err)
		return err
	}
	stderr, err := session.StderrPipe()
	if err != nil {
		logger.Error("[ssh][%s]Unable to request StderrPipe(): %s", ss.Host, err)
		return err
	}
	if err := session.Start(cmd); err != nil {
		logger.Error("[ssh][%s]Unable to execute command: %s", ss.Host, err)
		return err
	}
	doneout := make(chan bool, 1)
	doneerr := make(chan bool, 1)
	go func() {
		readPipe(ss.Host, stderr, true)
		doneerr <- true
	}()
	go func() {
		readPipe(ss.Host, stdout, false)
		doneout <- true
	}()
	<-doneerr
	<-doneout
	return session.Wait()
}

//CmdToString is in host exec cmd and replace to spilt str
func (ss *SSH) CmdToString(cmd, spilt string) string {
	data := ss.Cmd(cmd)
	if data != nil {
		str := string(data)
		str = strings.ReplaceAll(str, "\r\n", spilt)
		return str
	}
	return ""
}
