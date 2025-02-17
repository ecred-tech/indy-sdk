# Setup Indy SDK build environment for Arch-based distro (or Manjaro)

1. Install Rust and rustup (https://www.rust-lang.org/install.html).
2. Install required native libraries and utilities:

   ```
   sudo pacman -Sy && \
   sudo pacman -S \
       base-devel \
       cmake \
       openssl \
       sqlite \
       zeromq \
       ncurses \
       libsodium
   ```

3. Build `libindy`

   ```
   git clone https://github.com/hyperledger/indy-sdk.git
   cd ./indy-sdk/libindy
   cargo build
   cd ..
   ```
   
   **Note:** `libindy` debian package, installed from the apt repository, is statically linked with `libsodium`. 
   For manually building this can be achieved by passing `--features sodium_static` into `cargo build` command.


   
4. Run integration tests:
    [Start local nodes pool with Docker](/README.md#how-to-start-local-nodes-pool-with-docker)


     If you use this method then you have to specify the TEST_POOL_IP as specified below  when running the tests.

     It can be useful if we want to launch integration tests inside another container attached to
     the same docker network.

   * Run tests

     ```
     cd libindy
     RUST_TEST_THREADS=1 cargo test
     ```

     It is possible to change ip of test pool by providing of TEST_POOL_IP environment variable:

     ```
     RUST_TEST_THREADS=1 TEST_POOL_IP=10.0.0.2 cargo test
     ```

5. Build `indy-cli` (Optional)

   `indy-cli` is dependent on `libindy` and should be built after it.

   ```
   cd cli/
   RUSTFLAGS=" -L ../libindy/target/debug" cargo build
   ```
   If you have followed the instructions to build libindy above, the default build type will be `debug`

   Make sure to add the libindy to the path. Replace `/path/to` with the actual path to the libindy directory. Using bash:
   ```
   echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/libindy/target/{BUILD TYPE}" >> ~/.bashrc
   sudo ldconfig
   source ~/.bashrc
   ```
   To run indy-cli, navigate to `cli/target/debug` and run `./indy-cli`

See [libindy/ci/ubuntu.dockerfile](/libindy/ci/ubuntu.dockerfile) for example of Ubuntu based environment creation in Docker.
