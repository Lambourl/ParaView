# CMake RE
Use the following branch `feature/support-cmake-re` in the tipi team fork from this project

```bash 
git clone https://github.com/tipi-build/ParaView && cd ParaView
git checkout feature/support-cmake-re
git submodule init
git submodule update
```

The same branch and fork are also available for `vtk`. All of the following examples apply to both `vtk` and `ParaView`; only the project name changes. 

## Download your CMake RE authentication certificate

1) Head to the [Engflow UI](https://kernite.cluster.engflow.com):
  - From the Getting Started Page click on Generate and Download mTLS Certificate 
2) This will download a file named engflow-mTLS.zip
3) Unpack it in your $HOME/engflow-mTLS. It will be containing:
  - engflow.crt, 
  - engflow.key (never share the private .key file)

## Setup a ready-made container (example commands to copy/paste)

```bash 
mkdir -p ../`whoami`linux-kitware-paraview-mini-vT.w
mkdir -p ../generalized-toolchains
docker run --rm --init --detach --name `whoami`-linux-kitware-paraview-mini \
-u`id -u`:`id -g` --group-add tipi \
-e TIPI_DISABLE_AR_RANLIB_DRIVER=ON -e TIPI_CACHE_CONSUME_ONLY=ON -e TIPI_CACHE_FORCE_ENABLE=OFF -e HOME \
-v $HOME:$HOME:rw \
-v $PWD:$PWD:rw -w $PWD \
--mount type=bind,source=$PWD/../`whoami`linux-kitware-paraview-mini-vT.w,target=/usr/local/share/.tipi/vT.w/ \
--mount type=bind,source=$PWD/../generalized-toolchains,target=/usr/local/share/.tipi/environments/generalized/v1/ \
tipibuild/linux-kitware-paraview@sha256:e0417824c4d417eb4d363f08954d11b94f9e6eb4ec76cee391db72e1e281fb18 \
sleep infinity

docker exec -u 0 `whoami`-linux-kitware-paraview-mini useradd -d $HOME -u `id -u` `whoami`
docker exec -it `whoami`-linux-kitware-paraview-mini /bin/bash
```
Inside the container :

```bash
export RBE_service="kernite.cluster.engflow.com:443"
export RBE_tls_client_auth_key=${HOME}/engflow-mTLS/engflow.key
export RBE_tls_client_auth_cert=${HOME}/engflow-mTLS/engflow.crt
export RBE_local_resource_fraction="0.3"
export RBE_exec_strategy="racing"
export RBE_racing_bias="5"

cmake-re -S . -B ./build-mini -DCMAKE_TOOLCHAIN_FILE=toolchains/environments/linux-kitware-paraview-mini.cmake --host --distributed 
cmake-re --build ./build-mini --host --distributed -j500
```

There are several toolchains representing the different presets 
- `toolchains/environments/linux-kitware-paraview-mini.cmake`
- `toolchains/environments/linux-kitware-paraview-default.cmake`
- `toolchains/environments/linux-kitware-paraview-dev.cmake`

- `toolchains/environments/linux-kitware-paraview-vtk-mini.cmake`
- `toolchains/environments/linux-kitware-paraview-vtk-default.cmake`
- `toolchains/environments/linux-kitware-paraview-vtk-dev.cmake`

## Remote Execution Profile

Make RE prints an `Invocation ID: uuid-uuid-uuid-uuid-uuid`, that can be used to explore builds performance and cacheability with [Perfetto](https://ui.perfetto.dev) or similar chrome-tracing compatible tools.
It's also possible to force it to a user-defined value by setting before the build: `export RBE_invocation_id=$(uuidgen)`

Then it's possible to download the profile as follow :
```bash
curl --fail --cert $RBE_tls_client_auth_cert --key $RBE_tls_client_auth_key \
-H 'Accept: application/json' -o ./engflow_profile.json \
https://${RBE_service}/api/profiling/v1/instances/default/invocations/${RBE_invocation_id}
```

## cmake-re documentation

- https://tipi.build/documentation/0352-distributed-builds