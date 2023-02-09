# Drone melange Plugin

Drone plugin to run melange [melange](https://github.com/chainguard-dev/melange)

> **IMPORTANT:**
>
> - This plugin is under development and the parameters are subject to change
> - Currently only basic options of melange are supported. Plan to add options on need basis.

## Usage

The following settings changes this plugin's behavior,

- `config_file`: The melange configuration YAML file, path relative to drone pipeline.
- `output_dir`: The directory where the built packages will be saved. Defaults to `$DRONE_WORKSPACE/packages`
- `archs`: The `linux` architecture for which the packages will be built. Defaults `$(uname -m)`. Valid values are: `amd64`, `arm64`.
- `signing_key`: The signing key that will be used to sign the package. If not provided it will be generated.
- `env_file`: The environment file that will be preloaded and made available to build environment.

```yaml
kind: pipeline
type: docker
name: default

steps:
  - name: build image
    image: kameshsampath/melange-drone-plugin
    privileged: true
    settings:
      config_file: melange.yaml
      archs:
        - amd64
        - arm64
```

> **IMPORTANT**: Since melange spins lightweight containers while building, it is required to run the pipeline as **privileged: true**

## Examples

Checkout examples in folder [examples](./examples/). You need to have [drone](https://docs.drone.io/cli/install/) CLI to execute the examples locally.

| Example                                                     | Description                                                                                                                |
| :---------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------- |
| [All Architectures](./examples/all-architectures/README.md) | Builds packages for all supported architectures, `386`, `amd64`, `arm64`, `arm/v6`, `arm/v7`, `ppc64le`,`riscv64`,`s390x`. |
| [Defaults](./examples/defaults/README.md)                   | Build package for default host architecture `uname -m`                                                                     |
| [Multiple Architectures](./examples/multi-arch/README.md)   | Builds packages for specific architectures.                                                                                |
| [Output Directory](./examples/output-dir/README.md)         | Generates the packages in custom directory relative to drone pipeline                                                      |
| [Using Signing Key](./examples/use-signing-key/README.md)   | Build and sign the packages using configured signing key                                                                   |

## Building Plugin

The plugin relies on [apko](https://github.com/chainguard-dev/apko) and [melange](https://github.com/chainguard-dev/melange) for build.

The plugin build relies on:

- [crane](https://github.com/google/go-containerregistry)
- [limactl](https://github.com/lima-vm/lima)
- [taskfile](https://taskfile.dev)

Start `lima-vm` environment,

```shell
task build_env
```

Build plugin packages,

```shell
task packages
```

Build plugin container image,

```shell
task image
```

To publish the plugin to remote repository use,

```shell
task publish_plugin
```

## Testing

Build plugin container image,

```shell
task clean image load
```

Create `.env`

```shell
cat<<EOF | tee .env
PLUGIN_ARCHS=amd64,arm64
PLUGIN_CONFIG_FILE=melange.yaml
EOF
```

Create a `melange.yaml`,

```shell
cat<<EOF | tee melange.yaml
---
package:
  name: go-hello-world
  version: 0.0.2
  epoch: 0
  description: "a simple hello world rest api used for demos"
  target-architecture:
    - amd64
    -
  copyright:
    - paths:
        - "*"
      attestation: TODO
      license: Apache License 2.0
  dependencies:
    runtime:
environment:
  contents: {}
  packages:
    - go
pipeline:
  - uses: go/install
    with:
      package: github.com/kameshsampath/go-hello-world
      version: v\${{package.version}}
  - uses: strip
EOF
```

```shell
docker run --privileged --rm \
  --env-file=.env \
  --volume "$PWD:/workspace" \
  kameshsampath/melange-drone-plugin:latest
```

After the successful build you can can see the packages created in `$PWD/dist`.
