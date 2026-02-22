class Ladybird < Formula
  desc "Web browser"
  homepage "https://github.com/LadybirdBrowser/ladybird"
  url "https://github.com/LadybirdBrowser/ladybird.git",
      revision: "ad92622cf496a7ed10aa55c236486ae079f9b6e7"
  version "2026.02.18"
  license "BSD-2-Clause"

  # Version is pinned to a daily commit hash. Use `brew livecheck` to check for
  # a newer day's commit, then update revision + version manually.
  livecheck do
    url "https://api.github.com/repos/LadybirdBrowser/ladybird/branches/main"
    strategy :json do |json|
      Date.parse(json.dig("commit", "commit", "committer", "date")).strftime("%Y.%m.%d")
    end
  end

  # This build downloads dependencies via vcpkg during cmake configuration.
  # Network access is required. If the build fails with network errors, retry with:
  #   HOMEBREW_NO_SANDBOX=1 brew install bevanjkay/formulae/ladybird

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: ["15.0", :build]
  depends_on "ffmpeg"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on :macos
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "woff2"

  allow_network_access! :build

  def install
    # Create a vcpkg overlay port for libyuv to fix build failures on macOS.
    # Apple's clang does not support the +i8mm march extension or SVE in userspace
    # on arm64-apple-macos. The yuv_neon64 target is kept but compiled without the
    # i8mm flag; the yuv_sve target is omitted entirely. This portfile applies the
    # same changes as vcpkg's cmake.diff patch via vcpkg_replace_string.
    overlay = buildpath/"Meta/CMake/vcpkg/overlay-ports/libyuv"
    overlay.mkpath

    (overlay/"portfile.cmake").write <<~'EOS'
      vcpkg_from_git(
          OUT_SOURCE_PATH SOURCE_PATH
          URL https://chromium.googlesource.com/libyuv/libyuv
          REF d98915a654d3564e4802a0004add46221c4e4348
      )

      vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
          FEATURES
              tools BUILD_TOOLS
      )

      # Apply changes equivalent to vcpkg's cmake.diff, plus the macOS SVE/i8mm fix.

      # cmake.diff: add BUILD_TOOLS option
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          "option( UNIT_TEST \"Built unit tests\" OFF )"
          "option( BUILD_TOOLS \"Build tools\" OFF )\noption( UNIT_TEST \"Built unit tests\" OFF )"
      )

      # cmake.diff: wrap tools in if(BUILD_TOOLS) / endif()
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          "endif()\n\n# this creates the cpuid tool"
          "endif()\n\nif (BUILD_TOOLS)\n\n# this creates the cpuid tool"
      )
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          "\n\nfind_package ( JPEG )"
          "\n\nendif()\n\nfind_package ( JPEG )"
      )

      # cmake.diff: fix JPEG target linking
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          [=[  target_link_libraries( ${ly_lib_shared} ${JPEG_LIBRARY} )]=]
          [=[  target_link_libraries( ${ly_lib_static} PRIVATE JPEG::JPEG )
        target_link_libraries( ${ly_lib_shared} PRIVATE JPEG::JPEG )]=]
      )

      # cmake.diff: replace old-style install rules with cmake config-compatible ones
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          "install ( TARGETS yuvconvert DESTINATION bin )"
          [=[if (BUILD_TOOLS)
        install(TARGETS yuvconvert yuvconstants)
      endif()
      if(BUILD_SHARED_LIBS)
        target_include_directories(${ly_lib_shared} PUBLIC $<INSTALL_INTERFACE:include>)
        install(TARGETS ${ly_lib_shared} EXPORT libyuv-targets)
        set_target_properties(${ly_lib_shared} PROPERTIES EXPORT_NAME "${ly_lib_static}") # vcpkg legacy
        add_definitions(-DLIBYUV_BUILDING_SHARED_LIBRARY)
      else()
        target_include_directories(${ly_lib_static} PUBLIC $<INSTALL_INTERFACE:include>)
        install(TARGETS ${ly_lib_static} EXPORT libyuv-targets)
        set_target_properties(${ly_lib_shared} PROPERTIES EXCLUDE_FROM_ALL 1)
      endif()
      install(EXPORT libyuv-targets DESTINATION share/libyuv)]=]
      )
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          [=[install ( TARGETS ${ly_lib_static}						DESTINATION lib )]=]
          ""
      )
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          [=[install ( TARGETS ${ly_lib_shared} LIBRARY DESTINATION lib RUNTIME DESTINATION bin ARCHIVE DESTINATION lib )]=]
          ""
      )

      # macOS fix: build NEON kernels without the i8mm march flag; Apple's clang
      # does not support the +i8mm extension or SVE in userspace on arm64-apple-macos.
      vcpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
          [=[    # Enable AArch64 Neon dot-product and i8mm kernels.
          add_library(${ly_lib_name}_neon64 OBJECT
            ${ly_src_dir}/compare_neon64.cc
            ${ly_src_dir}/rotate_neon64.cc
            ${ly_src_dir}/row_neon64.cc
            ${ly_src_dir}/scale_neon64.cc)
          target_compile_options(${ly_lib_name}_neon64 PRIVATE -march=armv8.2-a+dotprod+i8mm)
          list(APPEND ly_lib_parts $<TARGET_OBJECTS:${ly_lib_name}_neon64>)

          # Enable AArch64 SVE kernels.
          add_library(${ly_lib_name}_sve OBJECT
            ${ly_src_dir}/row_sve.cc)
          target_compile_options(${ly_lib_name}_sve PRIVATE -march=armv8.5-a+i8mm+sve2)
          list(APPEND ly_lib_parts $<TARGET_OBJECTS:${ly_lib_name}_sve>)]=]
          [=[    # Enable AArch64 Neon dot-product and i8mm kernels.
          add_library(${ly_lib_name}_neon64 OBJECT
            ${ly_src_dir}/compare_neon64.cc
            ${ly_src_dir}/rotate_neon64.cc
            ${ly_src_dir}/row_neon64.cc
            ${ly_src_dir}/scale_neon64.cc)
          if(NOT APPLE)
            target_compile_options(${ly_lib_name}_neon64 PRIVATE -march=armv8.2-a+dotprod+i8mm)
          else()
            # Keep each -Xclang pair grouped; otherwise CMake may de-duplicate
            # repeated -Xclang entries and leave "+i8mm" as a stray argument.
            target_compile_options(${ly_lib_name}_neon64 PRIVATE
              "SHELL:-Xclang -target-feature -Xclang +dotprod"
              "SHELL:-Xclang -target-feature -Xclang +i8mm")
          endif()
          list(APPEND ly_lib_parts $<TARGET_OBJECTS:${ly_lib_name}_neon64>)

          if(NOT APPLE)
            # Enable AArch64 SVE kernels.
            add_library(${ly_lib_name}_sve OBJECT
              ${ly_src_dir}/row_sve.cc)
            target_compile_options(${ly_lib_name}_sve PRIVATE -march=armv8.5-a+i8mm+sve2)
            list(APPEND ly_lib_parts $<TARGET_OBJECTS:${ly_lib_name}_sve>)
          else()
            add_definitions(-DLIBYUV_DISABLE_SVE)
          endif()]=]
      )

      vcpkg_cmake_configure(
          SOURCE_PATH "${SOURCE_PATH}"
          OPTIONS
              ${FEATURE_OPTIONS}
          OPTIONS_DEBUG
              -DBUILD_TOOLS=OFF
      )

      vcpkg_cmake_install()
      vcpkg_cmake_config_fixup()
      if("tools" IN_LIST FEATURES)
          vcpkg_copy_tools(TOOL_NAMES yuvconvert yuvconstants AUTO_CLEAN)
      endif()

      if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
          vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libyuv/basic_types.h"
              "defined(LIBYUV_USING_SHARED_LIBRARY)" "1")
      endif()

      file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
      file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

      file(COPY "${CMAKE_CURRENT_LIST_DIR}/libyuv-config.cmake"
          DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
      file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage"
          DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

      vcpkg_cmake_get_vars(cmake_vars_file)
      include("${cmake_vars_file}")
      if(VCPKG_DETECTED_CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
          file(APPEND "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" [[

      Attention:
      You are using MSVC to compile libyuv. This build won't compile any
      of the acceleration codes, which results in a very slow library.
      See workarounds: https://github.com/microsoft/vcpkg/issues/28446
      ]])
      endif()

      vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
    EOS

    (overlay/"vcpkg.json").write <<~EOS
      {
        "name": "libyuv",
        "version": "1916",
        "description": "libyuv is an open source project that includes YUV scaling and conversion functionality",
        "homepage": "https://chromium.googlesource.com/libyuv/libyuv",
        "license": null,
        "dependencies": [
          "libjpeg-turbo",
          {
            "name": "vcpkg-cmake",
            "host": true
          },
          {
            "name": "vcpkg-cmake-config",
            "host": true
          },
          {
            "name": "vcpkg-cmake-get-vars",
            "host": true
          }
        ],
        "features": {
          "tools": {
            "description": "build command line tool",
            "supports": "!android & !ios & !xbox & !wasm32"
          }
        }
      }
    EOS

    (overlay/"libyuv-config.cmake").write <<~EOS
      include(CMakeFindDependencyMacro)
      find_dependency(JPEG)

      set(libyuv_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../include")
      include("${CMAKE_CURRENT_LIST_DIR}/libyuv-targets.cmake")
    EOS

    (overlay/"usage").write <<~EOS
      libyuv provides CMake targets:

        # Unofficial config package and target from vcpkg
        find_package(libyuv CONFIG REQUIRED)
        target_link_libraries(main PRIVATE yuv)
    EOS

    ENV["LADYBIRD_SOURCE_DIR"] = buildpath.to_s

    system "python3", "Meta/ladybird.py", "build", "--preset", "Release",
           "-j", ENV.make_jobs.to_s

    prefix.install "Build/release/bin/Ladybird.app"

    (bin/"ladybird").write <<~EOS
      #!/bin/bash
      exec open -a "#{opt_prefix}/Ladybird.app" --args "$@"
    EOS
    chmod 0755, bin/"ladybird"
  end

  test do
    assert_path_exists prefix/"Ladybird.app"
  end
end
