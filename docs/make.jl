using Documenter, MLDataStructs

makedocs(;
    modules=[MLDataStructs],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/joshday/MLDataStructs.jl/blob/{commit}{path}#L{line}",
    sitename="MLDataStructs.jl",
    authors="joshday <emailjoshday@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/joshday/MLDataStructs.jl",
)
