module NumDual

    import Base: size

    export Dual, x_Dual, complex_Dual, log_rama, exp_rama, pot_rama

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

    Base.:imag(x::Dual) = Dual(imag(x[1]),imag(x[2]))
    Base.:real(x::Dual) = Dual(real(x[1]),real(x[2]))
    Base.:conj(x::Dual) = Dual(conj(x[1]),conj(x[2]))
    Base.:angle(x::Dual) = Dual(angle(x[1]),angle(x[2]))

    function complex_Dual(f,x0::Complex)
        f_dev_real = f(Dual(x0,1))
        f_dev_imag = f(Dual(x0,im))
        if real(f_dev_real)[2]==imag(f_dev_imag)[2] && 
            real(f_dev_imag)[2]==-imag(f_dev_real)[2]
            return f(x_Dual(x0))
        else
            @error "La función no es analítica en este punto"
        end
    end

    function rama(x::Number,φ::Number)
        k = round((φ-angle(x))/(2*pi))
        if (φ-angle(x))/(2*pi) < k <= (φ-angle(x))/(2*pi) + 1
            return angle(x) + 2*pi*k
        else
            return angle(x) + 2*pi*(k+1)
        end
    end

    Base.:angle(x::Complex,φ::Real) = rama(x,φ)
    Base.:angle(x::Real,φ::Real) = rama(x,φ)
    log_rama(x::Number,φ::Real) = log(abs(x))+im*angle(x,φ)
    log_rama(x::Dual,φ::Real) = Dual(log_rama(x[1],φ),x[2]/x[1])
    pot_rama(x::Number,n::Real,φ::Real) = exp(n*log_rama(x,φ))
    pot_rama(x::Dual,n::Real,φ::Real) = Dual(pot_rama(x[1],n,φ),n*pot_rama(x[1],n-1,φ)*x[2])

end