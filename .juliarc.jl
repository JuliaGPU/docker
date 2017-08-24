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
        recompile()
        touch("/configured")
    catch
        warn("Setup failed, please re-run with DEBUG=1")
        rethrow()
    finally
        rm("/configuring")
    end
    exit()
end
