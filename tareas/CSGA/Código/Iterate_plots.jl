"""
    línea_paramétrica(x1, x2)

Forma paramétrica de la línea que pasa por \$x_1\$ y \$x_2\$.
Devuelve una función que depende del parámetro real \$t\$.
El segmento de recta comprendido entre \$x_1\$ y \$x_2\$ está parametrizado por \$t \\in [0, 1]\$.

Porque esta forma es lineal, la forma paramétrica de las coordenadas de la recta entre ambos puntos se pueden obtener de esta función utilizando las coordenadas de los puntos respectivas en su lugar.
"""
línea_paramétrica(x1, x2) = t -> (x2 - x1)*t + x1

"""
    puntos_línea(x1, x2, ts)

Devuelve el conjunto de puntos de la línea que pasa por \$x_1\$ y \$x_2\$ resultado de evaluar la forma paramétrica de la línea en el conjunto de puntos ```ts```.
"""
puntos_línea(x1, x2, ts) = línea_paramétrica(x1, x2).(ts)

"""
    análisis_iterado!(gráfica, x, fx, ffx, ts; linecolor = :green)

Dada una ```gráfica```, agrega a la misma los segmentos de línea entre los puntos \$(x, f(x))\$ y \$(f(x), f(x))\$, y \$(f(x), f(x))\$ y \$(f(x), f^{(2)}(x))\$.
Éstos segmentos corresponden a la representación de una iteración de \$f\$ con condición inicial \$x_0\$ en dos dimensiones.
Los segmentos incorporados tienen el color ```linecolor```.
"""
function análisis_iterado!(gráfica, x, fx, ffx, ts; linecolor = :green)
    
    x_fx_x = puntos_línea(x, fx, ts)
    x_fx_y = puntos_línea(fx, fx, ts)
    fx_ffx_x = x_fx_y
    fx_ffx_y = puntos_línea(fx, ffx, ts)
    
    plot!(gráfica, x_fx_x, x_fx_y, label = "", linecolor = linecolor, linestyle = :dash)
    plot!(gráfica, fx_ffx_x, fx_ffx_y, label = "", linecolor = linecolor, linestyle = :dash)
end

"""
    análisis_gráfico!(gráfica, f, n, x0; ts = 0:0.01:1, linecolor = :green)

Dado un mapeo \$f\$, un número de iteraciones \$n\$ y una condición inicial, \$x_0\$, genera el análisis gráfico correspondiente sobre la ```gráfica``` dada.
Los segmentos respectivos son mostrados en color ```linecolor``` y son muestreadas en los valores del parámetro ```ts```.
Se devuelve el máximo y el mínimo de los valores de los iterados para determinar los límites de graficación.
"""
function análisis_gráfico!(gráfica, f, n, x0; ts = 0:0.1:1, linecolor = :green)
    
    #Calculamos los iterados solicitados:    
    vector_iterados = iterados(f, n, x0)
    
    #Obtenemos el máximo y el mínimo:
    máx = maximum(vector_iterados)
    mín = minimum(vector_iterados)
      
    #El primer iterado:
    x = vector_iterados[1]
    fx = vector_iterados[2]
    x_fx_x = puntos_línea(x, x, ts)
    x_fx_y = puntos_línea(0, fx, ts)
        
    plot!(gráfica, x_fx_x, x_fx_y, label = "", linecolor = linecolor, linestyle = :dash)
        
    #Y los demás, basados en la identidad:
    for i in 1:(n - 1)
    
        análisis_iterado!(gráfica, vector_iterados[i:(i + 2)]..., ts, linecolor = linecolor)
    end
        
    return mín, máx
end

"""
    análisis_gráfico(f, n, x0s; paso = 0.1, linecolors = nothing)

Dado un mapeo \$f\$, un número de iteraciones \$n\$ y un arreglo de condiciones iniciales, ```x0s```, genera el análisis gráfico correspondiente.
Opcionalmente, se pueden especificar el tamaño de ```paso``` usado y el color de la órbita de cada condición inicial.
"""
function análisis_gráfico(f, n, x0s; paso = 0.1, linecolors = nothing)
    
    gráfica = plot()
    
    #Puntos para calcular las líneas:
    ts = 0:paso:1
    
    #Arrays para guardar valores límites:
    extremos = []
    
    #Definimos los colores de los iterados como fallback:
    if isnothing(linecolors)
        
        linecolors = fill(:green, length(x0s))
    end
    
    #Iteramos sobre las condiciones iniciales:
    for i in eachindex(x0s)
        
        mín, máx = análisis_gráfico!(gráfica, f, n, x0s[i]; ts = ts, linecolor = linecolors[i])
        
        push!(extremos, mín)
        push!(extremos, máx)
    end
    
    #Límites de las gráfica:
    xmín = minimum(extremos)
    xmáx = maximum(extremos)
    
    #Graficamos las funciones
    #Incorporamos más pasos al dominio de las funciones:
    xs = xmín:0.1*paso:xmáx
    
    plot!(gráfica, xs, x -> x, label = "Id", legend = :outerright, linecolor = :blue)
    plot!(gráfica, xs, f, label = "Función", linecolor = :red)
        
    return gráfica
end

"""
    paleta_colores(l)

Devuelve la paleta de los primeros \$l\$ colores usada por defecto.
"""
paleta_colores(l) =  get_color_palette(:auto, plot_color(:white), l)

export línea_paramétrica, puntos_línea, análisis_iterado!, análisis_gráfico, análisis_gráfico!, paleta_colores