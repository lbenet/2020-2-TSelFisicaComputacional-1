module NumDual

export Dual, var_dual

    mutable struct Dual{T <: Real}
        x :: T
        x′:: T  #donde x2 = x'
    end
    
    #constructor para poder definir duales a partir de dos tipos diferentes
    
    Dual(u::T,v::S) where {T<:Real,S<:Real} = Dual(promote(u,v)...)
    Dual(s::T) where {T <: Real} = Dual(s,zero(s))

    #Carga de algunas funciones para operar con duales
    Base.:+(u::Dual, v::Dual) = Dual(u.x+v.x,u.x′+v.x′)

    Base.:-(u::Dual, v::Dual) = Dual(u.x-v.x,u.x′-v.x′)

    Base.:*(u::Dual, v::Dual) = Dual(u.x * v.x, u.x*v.x′ + v.x*u.x′)

    Base.:/(u::Dual, v::Dual) = Dual(u.x/v.x,(u.x′*v.x - u.x*v.x′)/(v.x)^2)



    Base.convert(::Type{Dual}, x::Union{T,Dual}) where {T<:Real} = Dual(x)

    Base.promote(u::Dual, v::Real) = (u, Dual(v))
    Base.promote(u::Real, v::Dual) = (Dual(u), v)

    Base.:+(u::Dual,v::Real) = +(promote(u,v)...)
    Base.:+(u::Real,v::Dual) = +(promote(u,v)...)

    Base.:-(u::Dual,v::Real) = -(promote(u,v)...)
    Base.:-(u::Real,v::Dual) = -(promote(u,v)...)

    Base.:*(u::Dual,v::Real) = *(promote(u,v)...)
    Base.:*(u::Real,v::Dual) = *(promote(u,v)...)

    Base.:/(u::Dual,v::Real) = /(promote(u,v)...)
    Base.:/(u::Real,v::Dual) = /(promote(u,v)...)



    Base.:sin(a::Dual) = Dual(sin(a.x),(a.x′)*cos(a.x))

    Base.:cos(a::Dual) = Dual(cos(a.x),-(a.x′)*sin(a.x))

    Base.:tan(a::Dual) = Dual(tan(a.x),(a.x′)*sec(a.x)^2)

    Base.:^(a::Dual,n::Int) = Dual((a.x)^n,(a.x′)*n*(a.x)^(n-1))

    Base.:sqrt(a::Dual) = Dual(sqrt(a.x),(a.x′)*(1/2)*(1/sqrt(a.x)))

    Base.:exp(a::Dual) = Dual(exp(a.x),(a.x′)*(a.x)*exp(a.x))

    Base.:log(a::Dual) = Dual(log(a.x),(a.x′)/(a.x))


    var_dual(x_0::T) where {T<:Real} = Dual(x_0,one(x_0))
end
