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
