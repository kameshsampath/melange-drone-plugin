# Defaults

With just configuration file `go-hello-world.yaml`, no `archs` specified the build should generate package for the host architecture `uname -m`.

```shell
drone exec --trusted
```

A successful run should produce the packages in `packages` directory relative to `.drone.yml`
