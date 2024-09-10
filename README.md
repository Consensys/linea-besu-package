# Linea Besu Distribution

This project uses Gradle to manage dependencies, build tasks, and create distributions for linea-besu with 
all the necessary plugins to run a node for operators. The build process will also create a Docker image that can be 
used to run a node with a specific profile.

## Run with Docker

### Step 1. Download configuration files

You can start with the Docker Compose files located in the [docker-compose](https://github.com/Consensys/linea-besu-package/tree/main/docker) directory.

### Step 2. Update the Docker Compose file
In the docker-compose.yaml file, update the --p2p-host command to include your public IP address. For example:
```sh
--p2p-host=103.10.10.10
```

### Step 2. Start the Besu node
```sh
docker compose -f ./docker/docker-compose-follower-mainnet.yaml up
```
Alternatively, to run a node with a specific profile, set the `BESU_PROFILE` environment variable to the desired profile name:

```sh
docker run -e BESU_PROFILE=follower-mainnet consensys/linea-besu-package:latest
```

## Run with a binary distribution

### Step 1. Install Linea Besu from packaged binaries
*  Download the [linea-besu-package](https://github.com/Consensys/linea-besu-package/releases) binaries.
* Unpack the downloaded files and change into the besu-linea-package-&lt;release&gt;
directory.

Display Besu command line help to confirm installation:
```sh
bin/besu --help
```

### Step 2. Start the Besu client
```sh
besu --profile=follower-mainnet
```

## Build from source

The build process is driven by the following configuration file:

- [linea-besu/build.json](https://github.com/Consensys/linea-besu-package/tree/main/linea-besu/build.json): This file specifies the modules to be downloaded, extracted, or copied.

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
## How-To Release

Releases are automated using GitHub Actions and are triggered by pushing a tag that matches the
pattern `'v[0-9]+.[0-9]+.[0-9]+`. (e.g., `v1.0.0`, `v2.1.3`)

The tag creation will draft a release and include the distribution artifact uploaded as an asset.
   ```sh
   git tag -a 'v0.0.1' 5cf01f9  -m 'Release test'
   git push origin v1.0.0
   ```

Once the GitHub draft release is published, the Docker image will be created and pushed to the registry. Additionally, 
the `latest` tag will be updated to match this release.



## Profiles

This project leverages [Besu Profiles](https://besu.hyperledger.org/public-networks/how-to/use-configuration-file/profile) to enable multiple startup configurations for different node types.

During the build process, all TOML files located in the [linea-besu/profiles](https://github.com/Consensys/linea-besu-package/tree/main/linea-besu/profiles) directory will be incorporated into the package. These profiles are crucial for configuring the node, as each one specifies the necessary plugins and CLI options to ensure Besu operates correctly.

Each profile is a TOML file that outlines the plugins and CLI options to be used when starting the node. For example:

```toml
# required plugins to run a sequencer node
plugins=["LineaExtraDataPlugin","LineaEndpointServicePlugin","LineaTransactionPoolValidatorPlugin","LineaTransactionSelectorPlugin"]

# required options to configure the plugins above
plugin-linea-deny-list-path="config/denylist.mainnet.txt"
plugin-linea-module-limit-file-path="config/trace-limits.mainnet.toml"
# Other required plugin options
# ...

# Other Besu options
# ...
```

Currently, the following profiles are available:

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

