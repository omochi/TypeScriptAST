#!/bin/bash
set -ue

dir=swift-6.0.2-release/ubuntu2204
version=swift-6.0.2-RELEASE
tar_platform=ubuntu22.04

if [[ $(uname -m) == "aarch64" ]]; then
    dir=${dir}-aarch64
    tar_platform=${tar_platform}-aarch64
fi

url="https://download.swift.org/${dir}/${version}/${version}-${tar_platform}.tar.gz"

set -x
curl -fLo swift.tar.gz ${url}
tar -xf swift.tar.gz --strip-components=2 -C /usr
rm swift.tar.gz
