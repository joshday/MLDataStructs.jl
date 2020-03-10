module MLDataStructs

export MLData

#-----------------------------------------------------------------------------# Task
abstract type MLTask end 

for T in [:Regression, :Classification, :Clustering]
    @eval begin
        struct $T <: MLTask end 
        Base.show(io::IO, t::$T) = print(io, replace(string($T), r".*\." => ""))
    end
end
# struct Regression <: MLTask end 
# struct Classification <: MLTask end 
# struct Clustering <: MLTask end

#-----------------------------------------------------------------------------# MLData
const AN = Union{AbstractArray,  Nothing}

struct MLData{X <: AN, Y <: AN, W <: AN, T <: MLTask}
    x::X
    y::Y
    w::W
    task::T
    function MLData(x::X, y::Y, w::W, task::T) where {X,Y,W,T}
        nx, ny, nw = _nobs(x), _nobs(y), _nobs(w)
        n = max(nx, ny, nw)
        nx == ny == 0 && error("At least one of x or y must be provided.")
        all(x -> x==n || x==0, (nx, ny, nw)) || error("Components have different nobs.")
        new{X,Y,W,T}(x, y, w, task)
    end
end

MLData(;x=nothing, y=nothing, w=nothing, task=determine_task(x, y)) = MLData(x, y, w, task)

_nobs(x::AbstractArray) = size(x, 1)
_nobs(x::Nothing) = 0


function Base.show(io::IO, o::MLData)
    s = (!isnothing(o.x) && !isnothing(o.y)) ? "Supervised" : "Unsupervised"
    w = !isnothing(o.w) ? "Weighted" : "Un-weighted"
    print(io, "MLData | $s ($(o.task)) | $w\n ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬")
    o.x != nothing && print(io, "\n  > x: ", summary(o.x))
    o.y != nothing && print(io, "\n  > y: ", summary(o.y))
    o.w != nothing && print(io, "\n  > w: ", summary(o.w))
end

xy(o::MLData) = o.x, o.y
xyw(o::MLData) = o.x, o.y, o.w

nobs(o::MLData{<:AbstractArray}) = size(o.x, 1)
nobs(o::MLData{Nothing, <:AbstractArray}) = size(o.y, 1)

npredictors(o::MLData{<:AbstractArray}) = size(o.x, 2)
npredictors(o::MLData{Nothing}) = 0

#-----------------------------------------------------------------------------# determine_task
determine_task(x::AbstractArray, y::Nothing) = Clustering()
function determine_task(x::AbstractArray, y::AbstractArray)
    length(unique(y)) > .1 * _nobs(y) ? Regression() : Classification()
end

end # module
