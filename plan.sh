pkg_name=tikv
pkg_origin=qbr
pkg_version=2.0.3
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("MPL-2.0")
# pkg_source=http://download.pingcap.org/tidb-v${pkg_version}-linux-amd64-unportable.tar.gz
pkg_source=http://download.pingcap.org/tidb-v${pkg_version}-linux-amd64.tar.gz
pkg_shasum=5a5d153f3df4cb286de92619edae0f7de910f8f7c29a81385d2790ad13b5bb17
pkg_deps=(core/bash core/glibc core/gcc-libs)
pkg_build_deps=(core/patchelf)
pkg_bin_dirs=(bin)

# Optional.
# An associative array representing configuration data which should be gossiped to peers. The keys
# in this array represent the name the value will be assigned and the values represent the toml path
# to read the value.
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )

# Optional.
# An array of `pkg_exports` keys containing default values for which ports that this package
# exposes. These values are used as sensible defaults for other tools. For example, when exporting
# a package to a container format.
# pkg_exposes=(port ssl-port)


# Optional.
# An associative array representing services which you depend on and the configuration keys that
# you expect the service to export (by their `pkg_exports`). These binds *must* be set for the
# Supervisor to load the service. The loaded service will wait to run until it's bind becomes
# available. If the bind does not contain the expected keys, the service will not start
# successfully.
pkg_binds=(
  [pd]="client-port"
)

# Optional.
# The user to run the service as. The default is hab.
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"


pkg_description="TiKV is a distributed Key-Value database powered by Rust and Raft for TiDB; "
pkg_upstream_url="https://github.com/pingcap/tikv"

do_clean() {
  # remove any old binaries
  build_line $(rm -vrf ${HAB_CACHE_SRC_PATH}/tidb-v${pkg_version}-linux-amd64/)
  do_default_clean
}

do_prepare() {
  # the binaries are distributed together.  We'll separate them out now
  build_line $(cp -v ${HAB_CACHE_SRC_PATH}/tidb-v${pkg_version}-linux-amd64-unportable/bin/${pkg_name}* \
    ${HAB_CACHE_SRC_PATH}/$pkg_dirname)
}

do_build() {
  # Update our interpreter and add link to gcc shared object.
  # AKA patchelf black magic
  for i in ./${pkg_name}*; do
    build_line "patching: patchelf --interpreter $(pkg_path_for glibc)/lib64/ld-linux-x86-64.so.2 ${i}"
    patchelf --interpreter "$(pkg_path_for glibc)/lib64/ld-linux-x86-64.so.2" ${i}
    build_line "adding libgcc_s.so.1: patchelf --add-needed $(pkg_path_for gcc-libs)/lib/libgcc_s.so.1 ${i}"
    patchelf --add-needed "$(pkg_path_for gcc-libs)/lib/libgcc_s.so.1" ${i}
  done
}

do_install() {
  # iterate through all of the files in ${HAB_CACHE_SRC_PATH}/$pkg_dirname
  for i in ${pkg_name}*; do
    install_path=${pkg_prefix}/bin/${i}
    build_line "installing ${i} to ${install_path}"
    install -D ${i} ${install_path}
  done
}

do_strip() {
  # this kersplodes... skipping it 
  return 0
}
