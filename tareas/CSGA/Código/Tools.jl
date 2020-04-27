module Tools

include("NumDual.jl")
include("Iterate.jl")

end

module Plotting_tools

using Plots; pyplot()
using Tools

include("Iterate_plots.jl")

end
