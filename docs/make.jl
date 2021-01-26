using timbpMisc
using Documenter

makedocs(;
    modules=[timbpMisc],
    authors="Tim Badgery-Parker",
    sitename="timbpMisc.jl",
    format=Documenter.HTML(;
        canonical="https://timbp.github.io/timbpMisc.jl/stable",
    ),
)

deploydocs(;
    repo="github.com/timbp/timbpMisc.jl.git",
    devbranch = "main",
)
