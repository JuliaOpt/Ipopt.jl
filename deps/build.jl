using BinDeps

@BinDeps.setup

windllname = "IpOpt-vc10"
libipopt = library_dependency("libipopt", aliases=[windllname])

ipoptname = "Ipopt-3.11.4"

provides(Sources, URI("http://www.coin-or.org/download/source/Ipopt/$ipoptname.tgz"),
    libipopt, os = :Unix)

prefix=joinpath(BinDeps.depsdir(libipopt),"usr")
patchdir=BinDeps.depsdir(libipopt)
srcdir = joinpath(BinDeps.depsdir(libipopt),"src",ipoptname)

provides(SimpleBuild,
    (@build_steps begin
        GetSources(libipopt)
        @build_steps begin
            ChangeDirectory(srcdir)
            `cat $patchdir/ipopt-shlibs.patch` |> `patch -p1`
            @build_steps begin
                ChangeDirectory(joinpath(srcdir,"ThirdParty","Mumps"))
                `./get.Mumps`
            end
            `./configure --prefix=$prefix`
            `make install`
        end
    end),libipopt, os = :Unix)

# Windows
downloadsdir = BinDeps.downloadsdir(libipopt)
libdir = BinDeps.libdir(libipopt)
downloadname = "Ipopt-3.11.0-Win32-Win64-dll.7z"
windir = WORD_SIZE == 32 ? "Win32" : "x64"

provides(BuildProcess,
    (@build_steps begin
        FileDownloader("http://www.coin-or.org/download/binary/Ipopt/$downloadname", joinpath(downloadsdir, downloadname))
	CreateDirectory(BinDeps.srcdir(libipopt), true)
	FileUnpacker(joinpath(downloadsdir, downloadname), BinDeps.srcdir(libipopt), joinpath(BinDeps.srcdir(libipopt),"lib","Win32"))
	CreateDirectory(libdir, true)
	@build_steps begin
	    ChangeDirectory(joinpath(BinDeps.srcdir(libipopt),"lib",windir,"ReleaseMKL"))
	    FileRule(joinpath(libdir,"$(windllname).dll"), @build_steps begin
	        `cp *.dll $(libdir)`
	    end)
	end
     end), libipopt, os = :Windows)

@windows_only push!(BinDeps.defaults, BuildProcess)

@BinDeps.install

@windows_only pop!(BinDeps.defaults)
