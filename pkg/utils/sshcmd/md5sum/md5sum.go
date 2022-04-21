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

package md5sum

import (
	"crypto/md5"
	"fmt"
	"github.com/labring/cluster-image/pkg/utils/logger"
	"io"
	"os"
	"path/filepath"
)

func FromLocal(path string) string {
	file, err := os.Open(filepath.Clean(path))
	if err != nil {
		logger.Error("get file md5 failed %v", err)
		return ""
	}

	m := md5.New() // #nosec
	if _, err := io.Copy(m, file); err != nil {
		logger.Error("get file md5 failed %v", err)
		return ""
	}

	fileMd5 := fmt.Sprintf("%x", m.Sum(nil))
	return fileMd5
}
