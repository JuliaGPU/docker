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

if !ispath("/configured") && !ispath("/configuring")
    # this is the container's first run, build all packages and create a compile cache
    info("Performing first time setup")
    touch("/configuring")
    Pkg.build()
    recompile()
    rm("/configuring")
    touch("/configured")
    exit()
end
