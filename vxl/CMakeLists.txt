cmake_minimum_required(VERSION 2.8)

project(vxlBuilder)

include(ExternalProject)

set(VXL_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DBUILD_TESTING:BOOL=OFF
                   -DBUILD_EXAMPLES:BOOL=OFF
                   -DBUILD_CONTRIB_VIDL2:BOOL=OFF
                   -DBUILD_CORE_VIDEO=OFF
                   -DBUILD_CONTRIB=OFF
                   -DVXL_BUILD_DCMTK:BOOL=OFF
                   #-DVXL_FORCE_V3P_DCMTK:BOOL=OFF
                   -DVXL_FORCE_V3P_JPEG:BOOL=OFF
                   -DVXL_FORCE_V3P_PNG:BOOL=OFF
                   -DVXL_FORCE_V3P_TIFF:BOOL=OFF
                   -DVXL_FORCE_V3P_ZLIB:BOOL=OFF
)

if(WIN32)
    #VXL does not support the CMake "Shared Library" feature on MSVC.
    list(APPEND VXL_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=OFF)
else()
    list(APPEND VXL_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
endif()

getCachedUrl(http://freefr.dl.sourceforge.net/project/vxl/vxl/1.17/vxl-1.17.0.tar.gz CACHED_URL)

if(APPLE)
    set(VXL_PATCH_CMD patch -t -N -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/patch/osx.patch )
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(VXL_PATCH_CMD patch -t -N -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/patch/linux-v4l2.patch )
endif()

ExternalProject_Add(
    vxl
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib jpeg libpng tiff expat
    PATCH_COMMAND ${VXL_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${VXL_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(vxl CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VXL.cmake ${CMAKE_INSTALL_PREFIX}/fw-VXL.cmake
    COMMENT "Install configuration file"
)

