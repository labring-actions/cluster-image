## nerdctl

contaiNERD CTL - Docker-compatible CLI for containerd, with support for Compose, Rootless, eStargz, OCIcrypt, IPFS, ...

## Install

Install nerdctl with buildkit to `/usr/local/bin`, the image does not contain containerd, use the default containerd of the sealos cluster.

```shell
$ sealos run docker.io/labring/nerdctl:v1.2.1
```

## Uinstall

```shell
systemctl disable --now buildkit.socket >/dev/null 2>&1 || true
systemctl disable --now buildkit.service >/dev/null 2>&1 || true
rm -rf /etc/systemd/system/buildkit.service
rm -rf /etc/systemd/system/buildkit.socket
rm -rf /etc/buildkit/buildkitd.toml
rm -rf /usr/local/bin/buildctl
rm -rf /usr/local/bin/buildkitd
rm -rf /usr/local/bin/buildkit-qemu-aarch64
rm -rf /usr/local/bin/buildkit-qemu-arm
rm -rf /usr/local/bin/buildkit-qemu-i386
rm -rf /usr/local/bin/buildkit-qemu-mips64
rm -rf /usr/local/bin/buildkit-qemu-mips64el
rm -rf /usr/local/bin/buildkit-qemu-ppc64le
rm -rf /usr/local/bin/buildkit-qemu-riscv64
rm -rf /usr/local/bin/buildkit-qemu-s390x
rm -rf /usr/local/bin/buildkit-runc
rm -rf /usr/local/bin/nerdctl
```
