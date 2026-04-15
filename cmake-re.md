
```bash
docker run -it nilurova68440/tipi-ubuntu2404-paraview@sha256:803c75e02eb0763492431bd58ede338193dfab3fb5859f9df7c0653d0a708a70 /bin/bash
git clone https://github.com/Lambourl/ParaView && cd ParaView
git submodule init
git submodule update
export TIPI_DISABLE_AR_RANLIB_DRIVER=ON 
export TIPI_CACHE_CONSUME_ONLY=ON 
export TIPI_CACHE_FORCE_ENABLE=OFF
cmake-re -S . -B ./build -DCMAKE_TOOLCHAIN_FILE=toolchains/environments/linux-dev.cmake --host -vvv -j24
cmake-re --build ./build --host -vvv -j24
```

```bash
docker run -v <path-to-engflow-creds>:/home/tipi/engflow-mTLS -it nilurova68440/tipi-ubuntu2404-paraview@sha256:803c75e02eb0763492431bd58ede338193dfab3fb5859f9df7c0653d0a708a70 /bin/bash
git clone https://github.com/Lambourl/ParaView && cd ParaView
git submodule init
git submodule update
export RBE_service="<cluster>:443"
export RBE_tls_client_auth_key=/home/tipi/engflow-mTLS/engflow.key
export RBE_tls_client_auth_cert=/home/tipi/engflow-mTLS/engflow.crt
export TIPI_DISABLE_AR_RANLIB_DRIVER=ON 
export TIPI_CACHE_CONSUME_ONLY=ON 
export TIPI_CACHE_FORCE_ENABLE=OFF

#If you want to use the local machine for the builds too, you can specify the
# following 3 variables (will use 30% of local CPUs):
export RBE_local_resource_fraction="0.3"
export RBE_exec_strategy="racing"
export RBE_racing_bias="5"
cmake-re -S . -B ./build -DCMAKE_TOOLCHAIN_FILE=toolchains/environments/linux-dev.cmake --host -vvv  --distributed
cmake-re --build ./build --host --distributed -vvv -j500
```


```bash

docker run -v <path-to-engflow-creds>:/home/tipi/engflow-mTLS --runtime=runc -e NVIDIA_VISIBLE_DEVICES=void  -it nilurova68440/tipi-ubuntu2404-paraview-cuda@sha256:86c23ee7c25f1ccdd66ae16e0a7b9787e8588fe389bc2cae2254c0fdf954e13e /bin/bash
git clone https://github.com/Lambourl/ParaView && cd ParaView && git checkout feature/support-cuda
git submodule init
git submodule update
export RBE_service="<cluster>:443"
export RBE_tls_client_auth_key=/home/tipi/engflow-mTLS/engflow.key
export RBE_tls_client_auth_cert=/home/tipi/engflow-mTLS/engflow.crt
export TIPI_DISABLE_AR_RANLIB_DRIVER=ON 
export TIPI_CACHE_CONSUME_ONLY=ON 
export TIPI_CACHE_FORCE_ENABLE=OFF

#If you want to use the local machine for the builds too, you can specify the
# following 3 variables (will use 30% of local CPUs):
#export RBE_local_resource_fraction="0.3"
#export RBE_exec_strategy="racing"
#export RBE_racing_bias="5"
cmake-re -S . -B ./build -DCMAKE_TOOLCHAIN_FILE=toolchains/environments/linux-cuda.cmake --host -vvv  --distributed
cmake-re --build ./build --host --distributed -vvv -j500
```