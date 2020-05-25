# Módulo que implementa:
# * La estructura numérica "Dual".
# * Sobrecarga de operaciones aritméticas entre reales y duales.
# * Sobrecarga de funciones elementales para aplicarlas a números duales.

module NumDual 
    import Base: +, -, *, /, sin, cos, tan, ^, sqrt, exp, log, zero
    export var_dual, Dual

    """
    "Dual(x,y)" es una estructura mutable con partes 
    principal "x" y derivada "y" reales.
    """
    # \overleftrightarrow{z} = x + ϵy
    mutable struct Dual{T <: Real}
        x :: T
        y :: T
    end

    """
    Constructor de la estructura "Dual" que permite crear un objeto de este tipo
    sin importar que los argumentos que se reciban sean de distintos tipos.
    """
    # El operador "..." es para "aplanar" la tupla que resulra de "promote(x,y)"
    Dual(x::T, y::U) where {T <: Real, U <: Real} = Dual(promote(x, y)...)

    """
    Método que crea objetos del tipo Dual(x0, 0), recibe argumentos reales.
    """
    Dual(x::T) where {T <: Real} = Dual(x, zero(x)) 

    """
    Función que devuelve el dual (f(x_0),f'(x_0)),
    para f(x) = x, es decir Dual(x_0, 1).
    """
    var_dual(x0::T) where {T <: Real} = Dual(x0, 1)

    # Sobrecarga de operadores aritméticos
    # Dual-Dual
    +(z::Dual, w::Dual) = Dual(z.x + w.x, z.y + w.y)
    -(z::Dual, w::Dual) = Dual(z.x - w.x, z.y - w.y)
    *(z::Dual, w::Dual) = Dual(z.x * w.x, z.x * w.y + z.y * w.x)
    /(z::Dual, w::Dual) = Dual(z.x/w.x, (w.x * z.y - z.x * w.y)/w.x^2)
    # Dual-Real
    +(z::Dual, w::T) where {T <: Real} = Dual(z.x + w, z.y)
    -(z::Dual, w::T) where {T <: Real} = Dual(z.x - w, z.y)
    *(z::Dual, w::T) where {T <: Real} = Dual(z.x * w, z.y * w)
    /(z::T, w::Dual) where {T <: Real} = Dual(z / w.x, -z * w.y / w.x^2)
    # Real-Dual
    +(z::T, w::Dual) where {T <: Real} = Dual(z + w.x, w.y)   
    -(z::T, w::Dual) where {T <: Real} = Dual(z - w.x, w.y)    
    *(z::T, w::Dual) where {T <: Real} = Dual(z * w.x, z * w.y)
    /(z::Dual, w::T) where {T <: Real} = Dual(z.x / w, z.y / w)
    
    # Sobrecarga de funciones elementales f(z::Dual)
    sin(z::Dual) = Dual(sin(z.x), z.y*cos(z.x))
    cos(z::Dual) = Dual(cos(z.x), -z.y*sin(z.x))
    tan(z::Dual) = Dual(tan(z.x), z.y/cos(z.x)^2 )
    ^(z::Dual, n::Int) = Dual((z.x)^n, z.y*n*(z.x)^(n-1))
    sqrt(z::Dual) = Dual(sqrt(z.x), (0.5*z.y)/sqrt(z.x))
    exp(z::Dual) = Dual(exp(z.x), z.y*exp(z.x))
    log(z::Dual) = Dual(log(z.x), z.y/z.x)
    zero(x::Irrational) = 0.0
end