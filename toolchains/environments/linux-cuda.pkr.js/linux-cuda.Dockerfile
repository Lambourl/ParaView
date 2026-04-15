
ARG CUDA_IMAGE="nvidia/cuda:12.9.1-devel-ubuntu24.04@sha256:020bc241a628776338f4d4053fed4c38f6f7f3d7eb5919fecb8de313bb8ba47c"
FROM ${CUDA_IMAGE}
ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF
ENV CUDACXX=/usr/local/cuda/bin/nvcc

RUN apt-get update && apt-get install -y ca-certificates  git cmake build-essential pkg-config libgl1-mesa-dev libegl1-mesa-dev libxt-dev libqt5x11extras5-dev libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev python3-dev python3-numpy python3-pip libopenmpi-dev libtbb-dev ninja-build qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools mesa-common-dev mesa-utils freeglut3-dev curl sudo
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/bf984045460fb3cb1730d58056ac32437f0b2a01/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh && chmod 777 /usr/local/share/.tipi/.distro.mode && chmod -R 777 /usr/local/share/.tipi
COPY <<'EOF' /usr/local/bin/tipi-cuda-driver
#!/usr/bin/env bash
set -euo pipefail
export RBE_labels=type=tool,toolname=nvcc
if [[ $# -eq 0 ]]; then
  echo "error: no command provided" >&2
  exit 1
fi

if [[ -n "${TIPI_INTERCALATED_COMPILER_LAUNCHER:-}" ]]; then
  eval "set -- ${TIPI_INTERCALATED_COMPILER_LAUNCHER} \"\$@\""
fi

exec "$@"
EOF

RUN chmod 0777 /usr/local/bin/tipi-cuda-driver
ENV PATH=/usr/local/bin:$PATH

USER tipi
WORKDIR /home/tipi
EXPOSE 22

ENTRYPOINT []
CMD ["/bin/bash"]
