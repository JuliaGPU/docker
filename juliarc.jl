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
if !ispath("/configured") && !ispath("/configuring")
    info("Performing first time setup")
    try
        touch("/configuring")
        Pkg.build()

        info("Precompiling packages")
        recompile()
        touch("/configured")
    catch
        warn("Setup failed; please consult the troubleshooting section of the README.")
        rethrow()
    finally
        rm("/configuring")
    end
    info("""
        Done! Now commit this using:
              \$ docker commit $(gethostname()) local/juliagpu
              and use the local/juliagpu container instead.""")
    exit()
end
