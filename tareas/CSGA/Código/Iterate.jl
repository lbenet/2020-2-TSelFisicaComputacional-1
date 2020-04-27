"""
    iterados(f::Function, n::T, x0) where {T <: Integer}

Función que dado un mapeo \$f\$ y una condición inicial \$x_0\$, devuelve el vector \$(x_0, f(x_0), \\ldots, f^{(n)}(x_0)\$.
\$f\$ debe tener dominio y codominio iguales.
"""
function iterados(f::Function, n::T, x0) where {T <: Integer}
    
    @assert n >= 0
    
    iterados = fill(x0, n + 1)
    
    for i in 1:n
        
        iterados[i + 1] = f(iterados[i])
    end
    
    return iterados
end

"""
    iterados(f::Function, n::T) where {T <: Integer}

Forma funcional de ```iterados(f, n, x0)``` que permite variar la condición inicial \$x_0\$.
"""
iterados(f::Function, n::T) where {T <: Integer} = x0 -> iterados(f, n, x0)

"""
    iterar(f::Function, n::T, x0) where {T <: Integer}

Función que dado un mapeo \$f\$ y una condición inicial \$x_0\$, devuelve el resultado de iterar \$f\$ en \$x_0\$, \$n\$ veces.
Los valores intermedios son  usados para el cálculo, pero no son almacenados.
"""
function iterar(f::Function, n::T, x0) where {T <: Integer}
    
    @assert n >= 0
    
    x = x0
    
    for i in 1:n
        
        x = f(x) 
    end
    
    return x
end

"""
    iterar(f::Function, n::T) where {T <: Integer}

Forma funcional de ```iterar(f, n, x0)``` que permite variar la condición inicial \$x_0\$.
"""
iterar(f::Function, n::T) where {T <: Integer} = x0 -> iterar(f, n, x0)

"""
    puntos_fijos(f::Function, x0s::Array{T, 1}, número_iteraciones::Int = 1000) where {T <: Number}

Dada una función \$f\$ y un arreglo de condiciones iniciales, ```x0s```, busca los puntos fijos (i.e. soluciones a la ecuación \$ f(x) - x = 0\$) usando el método de Newton.
Devuelve un arreglo de los puntos fijos encontrados con las condiciones iniciales dadas.
"""
function puntos_fijos(f::Function, x0s::Array{T, 1}, número_iteraciones::Int = 1000) where {T <: Number}
    
    puntos_fijos = x -> f(x) - x
    
    convergencia = [Newton(puntos_fijos, x0, número_iteraciones) for x0 in x0s]
    unique!(convergencia)
    
    return convergencia
end

"""
    puntos_periodo(f::Function, n::Int, x0s::Array{T, 1}, número_iteraciones::Int = 1000) where {T <: Number}

Dada una función \$f\$ y un arreglo de condiciones iniciales, ```x0s```, busca los puntos de periodo \$n\$ (i.e. soluciones a la ecuación \$ f^{(n)}(x) - x = 0\$) usando el método de Newton.
Devuelve un arreglo de los puntos de periodo \$n\$ encontrados con las condiciones iniciales dadas.
"""
function puntos_periodo(f::Function, n::Int, x0s::Array{T, 1}, número_iteraciones::Int = 1000) where {T <: Number}
    
    @assert n > 0
    
    puntos_periodo_n = x -> iterar(f, n, x) - x
    
    convergencia = [Newton(puntos_periodo_n, x0, número_iteraciones) for x0 in x0s]
    unique!(convergencia)
    
    return convergencia
end

"""
    pertenencia(clases, dato; rtol = 0.0)

Dado un conjunto de valores ```clases```, devuelve el índice de la clase a la que dato pertenece (definido mediante ```isapprox``` con el parámetro ```rtol```).
En el caso de que no pertenezca a ninguna clase, devuelve cero.
"""
function pertenencia(clases, dato; rtol = 0.0)
    
    for index in eachindex(clases)
        
        if isapprox(clases[index], dato, rtol = rtol)
            
            return index
        end
    end
    
    return 0
end

"""
    convergencia(función, valores_convergencia, condición_inicial, rtol = 0.0)

Dada una ```función``` y un conjunto de ```valores_convergencia``` que definen las clases respectivas,
aplica la función a la ```condición_inicial``` y devuelve la clasificación de convergencia usando la función ```pertenencia``` con el parámetro ```rtol``` sobre el resultado de la función.
"""
function convergencia(función, valores_convergencia, condición_inicial; rtol = 0.0)
    
    y = función(condición_inicial)
        
    clasificación =  pertenencia(valores_convergencia, y, rtol = rtol)
        
    return clasificación
end

export iterados, iterar, puntos_fijos, puntos_periodo, pertenencia, convergencia