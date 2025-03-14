CC=arm-none-eabi-gcc \
cmake -S ../../ -B build \
-G Ninja \
-DPROJECT_NAME=app \
-DAPP_CMAKE=app.cmake \
-DCMAKE_BUILD_TYPE=Debug

cmake --build build