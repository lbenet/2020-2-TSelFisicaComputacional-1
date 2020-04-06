module NumDual

import Base: size

export Dual, x_Dual

struct Dual{T <: Number}
    x :: T
    x_prima :: T
end

function Dual(x::T_1, x_prima::T_2) where {T_1<:Number, T_2<:Number}
    x, x_prima = promote(x, x_prima)
    return Dual(x,x_prima)
end

size(::Dual{T}) where {T} = (2,)

function Base.getindex(v::Dual, i::Int)
    if i == 1
        return v.x
    elseif i == 2
        return v.x_prima
    else
        throw(AssertError)
    end
end

Base.:+(x::Dual, y::Dual) = Dual(x[1]+y[1],x[2]+y[2])
Base.:-(x::Dual, y::Dual) = Dual(x[1]-y[1],x[2]-y[2])
Base.:*(x::Dual, y::Dual) = Dual(x[1]*y[1],x[1]*y[2]+x[2]*y[1])
Base.:/(x::Dual, y::Dual) = Dual(x[1]/y[1],(y[1]*x[2]-x[1]*y[2])/(y[1])^2)

Dual(a::Number) = Dual(a,0)

Base.:+(x::Dual, y::Number) = +(x,Dual(y))
Base.:+(y::Number, x::Dual) = +(x,y)
Base.:-(x::Dual, y::Number) = -(x,Dual(y))
Base.:-(y::Number, x::Dual) = -(Dual(y),x)
Base.:*(x::Dual, y::Number) = *(x,Dual(y))
Base.:*(x::Number, y::Dual) = *(y,x)
Base.:/(x::Dual, y::Number) = /(x,Dual(y))
Base.:/(x::Number, y::Dual) = /(Dual(x),y)

x_Dual(x::Number) = Dual(x, 1)

Base.:^(x::Dual, n::Int) = Dual(x[1]^n,n*x[2]*x[1]^(n-1))
Base.:inv(x::Dual) = Dual(1,0)/ x
Base.:sin(x::Dual) = Dual(sin(x[1]),cos(x[1])*x[2])
Base.:cos(x::Dual) = Dual(cos(x[1]),-sin(x[1])*x[2])
Base.:tan(x::Dual) = Dual(tan(x[1]),(sec(x[1]))^2*x[2])
Base.:^(x::Dual, n::Int) = Dual(x[1]^n,n*x[2]*x[1]^(n-1))
Base.:sqrt(x::Dual) = Dual(sqrt(x[1]),(0.5/sqrt(x[1]))*x[2])
Base.:exp(x::Dual) = Dual(exp(x[1]),exp(x[1])*x[2])
Base.:log(x::Dual) = Dual(log(x[1]),x[2]/x[1])

end