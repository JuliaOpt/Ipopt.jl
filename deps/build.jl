using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libipopt"], :libipopt),
    ExecutableProduct(prefix, ["ipopt"], :amplexe),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaOpt/IpoptBuilder/releases/download/v3.12.10-1-static"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc4.tar.gz", "c538279784713baa9d4eec505ffd674f5dfb8b2b408e9efea7c712280ffdb9a7"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc7.tar.gz", "75a417624b8fcff81739aedd272453e927737d80fae2d66a9ef15280610f9e1d"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc8.tar.gz", "aa4ec6482bb8af253f9fb7fcae48b7925cd6f7c0b98314188ab376fb7b4dbcca"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc4.tar.gz", "d5ab53ef92e153b08f1ac889a5e9cb1966411dea320523c99d81c86b1e204bd3"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc7.tar.gz", "b7bf5ef24e300d73063b8c6730a861656d01b32e83c88e59ed1d2802ab6a4d58"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc8.tar.gz", "9ebc760de273a090f6a51b6ac3efc395f43a1d0b8d3a78840dfdcfb2b3a557a4"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc4.tar.gz", "049d166eb2774b40531f8bfd77cb26c1ebb4f1b155e6f8dfa16ff1f9c95a64cd"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc7.tar.gz", "b3ff1e0fd2508f0a540d8b695408d0363142011beaaa556d58b8fa5cd8fe60dd"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc8.tar.gz", "898844802ea87b44aec2fdda160b9a74bca25079410396dd357f88068b86a0cd"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc6.tar.gz", "05bbb0de01291f2e020640d794a9757f44ece04392148c90e445431eb5b31b12"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc7.tar.gz", "aa92b5ecb2e319182b136f84c1e54a5c4677375fc5cbb10cf9d0d190e1480ddc"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc8.tar.gz", "1701343eca9d3c38d46a9801c1f4eea633dceaee2a67b3fdf96c11b82ed09ce6"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc4.tar.gz", "a15de7b556959ccf184c08fe024cc970b0ed081381eaa266d0e7b4e315c8ca0d"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc7.tar.gz", "c73f82f56ed0127881b765fabb03df80133ba90e32bd55c1bc6530fcfe3d91ff"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc8.tar.gz", "e81aa4a07af52ac1c04f9299796bf4db7e38fc8dcd6c2526bf3141b9893104c6"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc4.tar.gz", "79d3ac61c596a7f28384aeced5199196ea4ae356f7b732718d226832654ec961"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc7.tar.gz", "92eab7ccd250979234447ebe164120f6d63614b0945c011fa4d280df8579828f"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc8.tar.gz", "f0eca1fc19fd7703f804b10ab4bc593739f23f472a717df00768534dda408292"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc6.tar.gz", "29c34972e2f7fb022054579ce5aaa22aff4e7323158b3be0b6554c1019fd8310"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc7.tar.gz", "f7bdbd43f0f356a65038e2c2cfea5151590080dbf125eb09802d3df5c274a114"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc8.tar.gz", "3d19545a532ce102a94901dd7cca37043ec11593c4052d0ede6b25fe9ecc25ea"),
)
                    
# To fix gcc4 bug in Windows
this_platform = platform_key_abi()
if typeof(this_platform)==Windows && this_platform.compiler_abi.gcc_version == :gcc4
   this_platform = Windows(arch(this_platform), libc=libc(this_platform), compiler_abi=CompilerABI(:gcc6))
end                    
                    
custom_library = false
if haskey(ENV,"JULIA_IPOPT_LIBRARY_PATH")
    custom_products = [LibraryProduct(ENV["JULIA_IPOPT_LIBRARY_PATH"],product.libnames,product.variable_name) for product in products]
    if all(satisfied(p; verbose=verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_IPOPT_LIBRARY_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_IPOPT_LIBRARY_PATH\") and run build again.")
    end
end     
                  
if !custom_library
                        
    # Install unsatisfied or updated dependencies:
    unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)

    dl_info = choose_download(download_info, platform_key_abi())
    if dl_info === nothing && unsatisfied
        # If we don't have a compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something even more ambitious here.
        error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
    end

    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
