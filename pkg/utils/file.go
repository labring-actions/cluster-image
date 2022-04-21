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
	"errors"
	"fmt"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"io"
	"os"
	"path/filepath"
)

func FileExist(path string) bool {
	_, err := os.Stat(path)
	return err == nil || os.IsExist(err)
}

func GetUserHomeDir() string {
	home, _ := os.UserHomeDir()
	return home
}

func GetPwd() string {
	pwd, _ := os.Getwd()
	return pwd
}

func ReadLines(fileName string) ([]string, error) {
	var lines []string
	if !FileExist(fileName) {
		return nil, errors.New("no such file")
	}
	file, err := os.Open(filepath.Clean(fileName))
	if err != nil {
		return nil, err
	}
	defer func() {
		if err := file.Close(); err != nil {
			logger.Fatal("failed to close file")
		}
	}()
	br := bufio.NewReader(file)
	for {
		line, _, c := br.ReadLine()
		if c == io.EOF {
			break
		}
		lines = append(lines, string(line))
	}
	return lines, nil
}

func CleanFiles(file ...string) error {
	for _, f := range file {
		err := os.RemoveAll(f)
		if err != nil {
			return fmt.Errorf("failed to clean file %s, %v", f, err)
		}
	}
	return nil
}
