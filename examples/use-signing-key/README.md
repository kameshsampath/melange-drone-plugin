# Use Custom Signing Key

```shell
drone exec --trusted
```

A successful run should produce the packages in `packages` directory relative to `.drone.yml`. The logs will also have a message like the following and no default keys would have been generated.

```shell
...
[default:157] 2023/02/08 16:52:24 melange: signing index packages/aarch64/APKINDEX.tar.gz with key `foo.rsa`
...
```
