#Código basado en complex.jl (https://github.com/JuliaLang/julia/blob/v1.4.0/base/complex.jl).

"""
    ComplexDual{T<:Real} <: Number

Complex number type with real and imaginary part of type `Dual{T}`.
"""
struct ComplexDual{T<:Real} <: Number
    re::Dual{T}
    im::Dual{T}
end

ComplexDual(x::Dual, y::Dual) = ComplexDual(promote(x,y)...)
ComplexDual(x::Dual) = ComplexDual(x, zero(x))
ComplexDual(x::Real) = ComplexDual(Dual(x), zero(Dual(x)))
ComplexDual(x::Complex) = ComplexDual(Dual(x.re), Dual(x.im))
ComplexDual(a::Real, b::Real, c::Real, d::Real) = ComplexDual(Dual(a, b), Dual(c, d))

ComplexDual{T}(x::S) where {T<:Real,S<:Real} = begin U = promote_type(T, S); ComplexDual{U}(Dual{U}(x),zero(Dual{U}(x))) end
ComplexDual{T}(x::Dual{S}) where {T<:Real,S<:Real} = begin U = promote_type(T, S); ComplexDual{U}(Dual{U}(x),zero(Dual{U}(x))) end
ComplexDual{T}(x::Complex{S}) where {T<:Real,S<:Real} = begin U = promote_type(T, S); ComplexDual{U}(Dual{U}(x.re),Dual{U}(x.im)) end
ComplexDual{T}(z::ComplexDual) where {T<:Real} = ComplexDual{T}(real(z),imag(z))

ComplexDual(z::ComplexDual) = z

Base.promote_rule(::Type{ComplexDual{T}}, ::Type{S}) where {T<:Real,S<:Real} = ComplexDual{promote_type(T,S)}
Base.promote_rule(::Type{ComplexDual{T}}, ::Type{Complex{S}}) where {T<:Real,S<:Real} = ComplexDual{promote_type(T,S)}
Base.promote_rule(::Type{Complex{T}}, ::Type{Dual{S}}) where {T<:Real,S<:Real} = ComplexDual{promote_type(T,S)}
Base.promote_rule(::Type{ComplexDual{T}}, ::Type{Dual{S}}) where {T<:Real,S<:Real} = ComplexDual{promote_type(T,S)}
Base.promote_rule(::Type{ComplexDual{T}}, ::Type{ComplexDual{S}}) where {T<:Real,S<:Real} = ComplexDual{promote_type(T,S)}

Base.real(z::ComplexDual) = z.re
Base.imag(z::ComplexDual) = z.im

principal(z::ComplexDual) = Complex(principal(z.re), principal(z.im))
derivada(z::ComplexDual) = Complex(derivada(z.re), derivada(z.im))

function Base.show(io::IO, a::ComplexDual{T}) where {T <: Real}

    if !(a.im.p === -0.0) & !signbit(a.im.p)

        print(io, "($(a.re)) + ($(a.im))im")
    else

        print(io, "($(a.re)) - ($(-a.im))im")
    end
end

Base.show(io::IO, ::MIME"text/plain", a::ComplexDual{T}) where {T <: Real} = print(io, "ComplexDual{$T}: $a")

Base.conj(z::ComplexDual) = ComplexDual(real(z),-imag(z))
Base.abs2(z::ComplexDual) = real(z)*real(z) + imag(z)*imag(z)
Base.abs(z::ComplexDual) = sqrt(abs2(z))

Base.:+(z::ComplexDual) = ComplexDual(+real(z), +imag(z))
Base.:-(z::ComplexDual) = ComplexDual(-real(z), -imag(z))
Base.:+(z::ComplexDual, w::ComplexDual) = ComplexDual(real(z) + real(w), imag(z) + imag(w))
Base.:-(z::ComplexDual, w::ComplexDual) = ComplexDual(real(z) - real(w), imag(z) - imag(w))
Base.:*(z::ComplexDual, w::ComplexDual) = ComplexDual(real(z) * real(w) - imag(z) * imag(w),
                                    real(z) * imag(w) + imag(z) * real(w))

function Base.inv(a::ComplexDual)

    a1 = a.re.p; a2 = a.re.d; a3 = a.im.p; a4 = a.im.d

    k = (a1^2 + a3^2)
    k2 = k^2
    l = (a3^2 - a1^2)

    b1 = a1/k
    b2 = (a2*l - 2*a1*a2*a4)/k2
    b3 = -a3/k
    b4 = (a4*l + 2*a1*a2*a3)/k2

    return ComplexDual(b1, b2, b3, b4)
end

Base.:/(a::ComplexDual, b::ComplexDual) = a*inv(b)

function Base.angle(z::ComplexDual)

    rea = real(z)
    ima = imag(z)

    if rea.p == 0

        return acot(rea/ima)
    else

        return atan(ima/rea)
    end
end

Base.cis(theta::Dual) = ComplexDual(sin(theta), cos(theta))

Base.sqrt(a::ComplexDual) = sqrt(abs(a))*cis(angle(a))
Base.log(a::ComplexDual) = log(abs(a)) + im*angle(a)
Base.exp(a::ComplexDual) = begin rea = real(a); ima = imag(a); exp(rea)*(cos(ima) + im*sin(ima)) end

Base.:^(a::ComplexDual, k::ComplexDual) = exp(k*log(a))

Base.cos(a::ComplexDual) = (exp(im*a) + exp(-im*a))/2
Base.sin(a::ComplexDual) = (exp(im*a) - exp(-im*a))/(2*im)
Base.tan(a::ComplexDual) = sin(a)/cos(a)

Base.cosh(a::ComplexDual) = (exp(a) + exp(-a))/2
Base.sinh(a::ComplexDual) = (exp(a) - exp(-a))/2
Base.tanh(a::ComplexDual) = sinh(a)/cosh(a)

"""
    var_ComplexDual(x::T) where {T <: Real}

Construye el dual complejo \$(x + \\epsilon)\$ usado para calcular derivadas de funciones usando la inclusión de los reales mediante la función identidad.
"""
var_ComplexDual(x::Real) = ComplexDual(x, 1, 0, 0)

"""
    var_ComplexDual(x::T) where {T <: Complex}

Construye el dual complejo \$(\\mathbb{Re}x + \\epsilon) + i(\\mathbb{Im}x )\$ usado para calcular derivadas de funciones usando la inclusión de los complejos mediante la función identidad.
"""
var_ComplexDual(x::Complex) = ComplexDual(x.re, 1, x.im, 0)

"""
    derivada(f::Function, x::T) where {T <: Complex}

Calcula la derivada de \$f\$ en el punto \$x\$ mediante duales complejos.
"""
derivada(f::Function, x::T) where {T <: Complex} = f(var_ComplexDual(x)) |> derivada

export ComplexDual, var_ComplexDual
