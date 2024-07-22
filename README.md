
# Linea besu distribution

This project uses Gradle to manage dependencies, build tasks, and create distributions for linea-besu with all the necessary plugins to run a node for operators. 
The build process is configured to download, extract, and copy various modules as specified in the config/modules.json file. Additionally, it includes tasks for building Docker images.

## Configuration

The build process is driven by the following configuration files:

### `config/modules.json`

This file specifies the modules to be downloaded, extracted, or copied. Below is an example configuration:

```json
{
  "distIdentifier": "linea-besu",
  "distOutput": "besu",
  "modules": [
    {
      "type": "extract",
      "name": "besu",
      "url": "https://artifacts.consensys.net/public/linea-besu/raw/names/linea-besu.tar.gz/versions/{version}/linea-besu-{version}.tar.gz",
      "version": "version"
    },
    {
      "type": "download",
      "name": "linea-sequencer",
      "url": "https://github.com/Consensys/linea-sequencer/releases/download/v{version}/linea-sequencer-v{version}.jar",
      "version": "version",
      "outputDir": "plugins"
    },
    {
      "type": "download",
      "name": "linea-arithmetization",
      "url": "https://github.com/Consensys/linea-arithmetization/releases/download/v{version}/linea-arithmetization-v{version}.jar",
      "version": "version",
      "outputDir": "plugins"
    },
    {
      "type": "download",
      "name": "besu-shomei-plugin",
      "url": "https://github.com/Consensys/besu-shomei-plugin/releases/download/v{version}/besu-shomei-plugin-v{version}.jar",
      "version": "version",
      "outputDir": "plugins"
    },
    {
      "type": "copy",
      "name": "profiles",
      "src": "config/profiles",
      "outputDir": "profiles"
    },
    {
      "type": "copy",
      "name": "trace-limits",
      "src": "config/trace-limits",
      "outputDir": "trace-limits"
    },
    {
      "type": "copy",
      "name": "config",
      "src": "config/config",
      "outputDir": "config"
    }
  ]
}
```

### `gradle.properties`

This file provides additional properties used in the build process:

```
releaseVersion=0.0.4-SNAPSHOT
distributionIdentifier=linea-plugins
dockerOrgName=consensys
dockerArtifactName=linea-besu-full
```

## Build Flow


1. **Process Modules**: The `processModules` task depends on all the individual module tasks (`extractBesu`, `downloadLineaSequencer`, `downloadLineaArithmetization`, `downloadBesuShomeiPlugin`, `copyProfiles`, `copyTraceLimits`, `copyConfig`). Running `processModules` will execute all these tasks in sequence.

2. **Prepare Distribution Folder**: The `prepareDistFolder` task depends on `processModules`. It prepares the distribution folder by copying the processed modules into a new folder named `${config.distIdentifier}-${version}` within the `$buildDir/tar` directory.

3. **Create Distribution Tar**: The `distTar` task depends on `prepareDistFolder`. It creates a tar.gz archive of the prepared distribution folder.

4. **Install Distribution**: The `installDist` task depends on `distTar`. It extracts the tar.gz archive into the `$buildDir/distributions/install` directory.

5. **Create Distribution Zip**: The `distZip` task depends on `installDist`. It creates a zip archive of the installed distribution.

6. **Verify Distributions**: The `verifyDistributions` task depends on `distTar` and `distZip`. It verifies that the tar.gz and zip archives are not suspiciously small.

### Docker Build Flow

1. **Docker Distribution Untar**

    - **Task**: `dockerDistUntar`
    - **Action**:
        - Untar the distribution tar file into the `build/docker-besu/` directory.
        - Rename the top-level directory from `besu-<version>` to `besu`.

2. **Build Docker Image**

    - **Task**: `distDocker`
    - **Action**:
        - Copy the Dockerfile into the `build/docker-besu/` directory.
        - Build the Docker image using the specified Dockerfile and build arguments.

### Running the Build

To run the entire build process, including downloading, extracting, copying modules, and creating distributions, you can execute:

```sh
gradle build
```

To build the Docker image, you can execute:

```sh
gradle distDocker
```

## Artifacts

The build script defines artifacts for publishing:

- `distTar`: The tar archive of the distribution
- `distZip`: The zip archive of the distribution

##  How-To Release

Releases are automated using GitHub Actions and are triggered by pushing a tag that matches the pattern `v*`.

### Steps to Create a Release

1. **Create and Push a Tag**

   Create a new tag that follows the pattern `v*` (e.g., `v1.0.0`, `v2.1.3`). You can create and push a tag using the following Git commands:

   ```sh
   git tag v1.0.0
   git push origin v1.0.0
   ```

### Running with Docker
```
docker run -e BESU_PROFILE=shomei consensys/linea-besu-full:0.0.4-SNAPSHOT
```
You can run the project using Docker Compose. Below is an example docker-compose.yml file:
```
version: '3'
services:
  besu-mainnet-node:
    image: consensys/linea-besu-full:0.0.4-SNAPSHOT
    command: --profile=sequencer --p2p-host=YOUR_IP_ADDRESS
    ports:
      - 30303:30303
      - 8545:8545
      - 8546:8546
```
