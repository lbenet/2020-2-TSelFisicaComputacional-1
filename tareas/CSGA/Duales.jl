module Duales

"""
    Dual{T <: Real}

Tipo estático que representa a un número dual con entradas de tipo \$T\$. Se puede acceder a la parte principal mediante el campo `p` y a la parte derivada mediante el campo `d`.
"""
struct Dual{T <: Real} <: Number
    p::T
    d::T
end

#Constructores:
Dual(x::T) where {T <: Real} = Dual(x, zero(x))
Dual(p::T, d::S) where {T <: Real, S <: Real} = Dual(promote(p, d)...)
Dual{T}(x::S) where {T <: Real, S <: Real} = Dual(convert(T, x))
Dual{T}(x::Dual{S}) where {T <: Real, S <: Real} = Dual(convert(T, x.p), convert(T, x.d))

#Conversión entre tipos:
Base.convert(::Type{Dual}, x::T) where {T <: Real} = Dual{T}(x)
Base.convert(::Type{Dual{T}}, x::Dual{S}) where {T <: Real, S <: Real} = Dual{T}(x)

#Promoción entre tipos:
Base.promote_rule(::Type{Dual{T}}, ::Type{S}) where {T <: Real, S <: Real} = Dual{promote_type(T, S)}
Base.promote_rule(::Type{Dual{T}}, ::Type{Dual{S}}) where {T <: Real, S <: Real} = Dual{promote_type(T, S)}

import Base: show, +, -, *, /, sin, cos, tan, ^, sqrt, exp, log

#Display:
#Para implementar un poco de "eyecandy", conviene colocar el signo de la parte derivada antes del número ϵ. Para hacer esto podemos usar la función ```signbit```:
function show(io::IO, a::Dual{T}) where {T <: Real}

    if signbit(a.d)

        print(io, "$(a.p) - $(abs(a.d))ϵ ")

    else

        print(io, "$(a.p) + $(abs(a.d))ϵ ")
    end
end

#Para tener un poco más de información sobre el tipo de los campos en caso de tener un solo elemento:
show(io::IO, ::MIME"text/plain", a::Dual{T}) where {T <: Real} = print(io, "Dual{$T}: $a")

#Operaciones aritméticas:
+(a::Dual, b::Dual) = Dual(a.p + b.p, a.d + b.d)
-(a::Dual, b::Dual) = Dual(a.p - b.p, a.d - b.d)
*(a::Dual, b::Dual) = Dual(a.p * b.p, a.p * b.d + b.p * a.d)

#Para mayor claridad definimos el cociente de forma más explícita:
function /(a::Dual, b::Dual)

    c_p = a.p / b.p
    c_d = a.d / b.p - (b.d / b.p)*c_p

    return Dual(c_p, c_d)
end

sin(a::Dual) = Dual(sin(a.p), a.d*cos(a.p))
cos(a::Dual) = Dual(cos(a.p), -a.d*sin(a.p))
tan(a::Dual) = Dual(tan(a.p), a.d*sec(a.p)^2)

function ^(a::Dual, x::T) where {T <: Real}

    if x == zero(x)

        return one(a)

    elseif x == one(x)

        return a

    elseif x > 0

        return Dual(a.p^x, x*(a.p^(x-1))*a.d)

    elseif x < 0

        return ^(inv(a), -x)
    end
end

#Incluimos un pequeño análisis de tipo en el caso de una potencia entera para tener el comportamiento esperado (si elevamos un Dual{Int64} a una potencia entera, es razonable esperar un Dual{Int64} y no un flotante a menos que sea necesario.)
function ^(a::Dual{T}, x::S) where {T <: Real, S <: Integer}

    end_type = promote_type(T, S)

    if x == zero(x)

        return Dual{end_type}(one(a))

    elseif x == one(x)

        return Dual{end_type}(a)

    elseif x > 0

        return Dual{end_type}(a.p^x, x*(a.p^(x-1))*a.d)

    elseif x < 0

        return ^(inv(a), -x)
    end
end

function ^(a::Dual, x::T) where {T <: Rational}

    if x == zero(x)

        return one(a)

    elseif x == one(x)

        return a

    elseif x > 0

        return Dual(a.p^x, x*(a.p^(x-1))*a.d)

    elseif x < 0

        return ^(inv(a), -x)
    end
end

function sqrt(a::Dual)

    s = sqrt(a.p)

    return Dual(s, a.d/(2*s))
end

function exp(a::Dual)

    e = exp(a.p)

    return Dual(e, a.d*e)
end

log(a::Dual) = Dual(log(a.p), a.d/a.p)

export Dual
end
