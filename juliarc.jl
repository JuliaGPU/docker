# JuliaLang/julia#16409
function recompile()
    for pkg in keys(Pkg.installed())
        try
            eval(Expr(:toplevel, Expr(:using, Symbol(pkg))))
        catch err
            warn("Unable to compile $pkg")
            warn(err)
        end
    end
end

# first time setup
if !ispath(Pkg.dir())
    info("Performing first time setup")
    try
        for entry in readdir("/template")
            cp(joinpath("/template", entry), joinpath("/pkg", entry))
        end
        Pkg.build()

        info("Precompiling packages")
        recompile()
    catch
        warn("Setup failed; please consult the troubleshooting section of the README.")
        if ispath(Pkg.dir())
            rm(Pkg.dir(); force=true, recursive=true)
        end
        rethrow()
    end
    exit()
end
