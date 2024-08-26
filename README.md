# Linea Besu Distribution

This project uses Gradle to manage dependencies, build tasks, and create distributions for linea-besu with 
all the necessary plugins to run a node for operators. The build process is configured to download, extract, 
and copy various modules as specified in the [linea-besu/build.json](https://github.com/Consensys/linea-besu-package/tree/main/linea-besu/build.json) 
file. Additionally, it includes tasks for building Docker images.

## How-To Release

Releases are automated using GitHub Actions and are triggered by pushing a tag that matches the
pattern `'v[0-9]+.[0-9]+.[0-9]+`. (e.g., `v1.0.0`, `v2.1.3`)


### Create and Push a Tag

   The tag creation will draft a release and include the distribution artifact uploaded as an asset.
   ```sh
   git tag -a 'v0.0.1' 5cf01f9  -m 'Release test'
   git push origin v1.0.0
   ```

### Publish the release

   Once the draft release is published, the Docker image will also be created and published to registry.

## Running with Docker

You can start with the Docker Compose files located in the [docker-compose](https://github.com/Consensys/linea-besu-package/tree/main/docker) directory.

```sh
docker compose -f ./docker/docker-compose-follower-mainnet.yaml up
```
Alternatively, to run a node with a specific profile, set the `BESU_PROFILE` environment variable to the desired profile name:

```sh
docker run -e BESU_PROFILE=follower-mainnet consensys/linea-besu-package:latest
```


The build process will incorporate all the TOML files located in the
[linea-besu/profiles](https://github.com/Consensys/linea-besu-package/tree/main/linea-besu/profiles) 
directory into the package. These profiles are essential for configuring the node, as each one specifies the necessary 
plugins and CLI options to ensure Besu operates correctly.  Currently, the following profiles are available:

| Profile Name         | Description                                | Status                |
|----------------------|--------------------------------------------|-----------------------|
| [`follower-mainnet`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/follower-mainnet.toml)   | Creates a follower node on the Linea mainnet.   | ✅                   |
| [`follower-sepolia`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/follower-sepolia.toml)   | Creates a follower node on the Linea Sepolia testnet. | ✅                   |
| [`sequencer-mainnet`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/sequencer-mainnet.toml)  | Creates a sequencer node on the Linea mainnet.  | ⚠️                    |
| [`sequencer-sepolia`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/sequencer-sepolia.toml)  | Creates a sequencer node on the Linea Sepolia testnet. | ⚠️                    |
| [`shomei-mainnet`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/shomei-mainnet.toml)     | Creates a Shomei node on the Linea mainnet.     | ⚠️                    |
| [`shomei-sepolia`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/shomei-sepolia.toml)     | Creates a Shomei node on the Linea Sepolia testnet. | ⚠️                    |
| [`tracer-mainnet`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/tracer-mainnet.toml)     | Creates a tracer node on the Linea mainnet.     | ⚠️                    |
| [`tracer-sepolia`](https://github.com/Consensys/linea-besu-package/blob/main/linea-besu/profiles/tracer-sepolia.toml)     | Creates a tracer node on the Linea Sepolia testnet. | ⚠️                    |

## Update the Build Configuration

The build process is driven by the following configuration file:

- [linea-besu/build.json](https://github.com/Consensys/linea-besu-package/tree/main/linea-besu/build.json): This file specifies the modules to be downloaded, extracted, or copied.

### Building Locally

To execute the complete build process, which includes downloading, extracting, copying plugins, and creating 
distributions, use the following command:

```sh
./gradlew build
```

This command will generate two distribution files:

- `/build/distributions/linea-besu-package-<version>.tar.gz`
- `/build/distributions/linea-besu-package-<version>.zip`

To create the Docker image, run:

```sh
./gradlew distDocker
```
