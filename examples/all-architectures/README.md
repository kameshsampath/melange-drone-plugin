# All Supported Architectures

With just configuration file `go-hello-world.yaml`, with `archs` to be `all` the build should generate packages for all supported architectures `386`, `amd64`, `arm64`, `arm/v6`, `arm/v7`, `ppc64le`,`riscv64`,`s390x`.

```shell
drone exec --trusted
```

A successful run should produce the packages in `packages` directory relative to `.drone.yml`
