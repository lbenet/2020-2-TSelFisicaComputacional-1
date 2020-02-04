# Instalació\n de `Julia`

1. Descargar la versión Julia v1.3.1 (2019-12-30) para la plataforma en la que
trabajen, de [aquí](https://julialang.org/downloads/) e instalarlo. Sean
especialmente cuidadosos en escoger la versión apropiada (32 o 64 bits);
computadoras relativamente modernas usan 64 bits. Sugiero instalar la
versión a partir de los binarios.

2. Correr el ejecutable de `Julia` que instalaron; el lugar donde se encuentra
el ejecutable depende de la plataforma que usen. Esto debería abrir una nueva
ventana con el *prompt* `julia> `; esta ventana también se conoce como REPL
("Read-Eval-Print-Loop").

    <img src="../images/julia_prompt.png" alt="alt text" width="700" height="200"/>

    `Julia` puede ser usado desde la terminal (REPL), usando el Jupyter notebook
    (o JupyterLab), o usando [**JUNO-IDE**](https://junolab.org/); el último
    requiere la instalación del editor ATOM.



3. Para usar `Julia` desde el Jupyter notebook, se requiere instalar el paquete [`IJulia`](https://github.com/JuliaLang/IJulia.jl); instalaremos además el
paquete [`Weave`](https://github.com/JunoLab/Weave.jl), [`Plots`](https://github.com/JuliaPlots/Plots.jl) junto con los
graficadores [`PyPlot`](https://github.com/JuliaPy/PyPlot.jl) y
[`GR`](https://github.com/jheinen/GR.jl): Al apretar la tecla `]` en la ventana
donde corre Julia, se abrirá el manejador de paqueterías de Julia, lo que se
aprecia a través del prompt `(v1.3) pkg> `.

    Dentro del manejador de paquetes, agregaremos las paqueterías usando el comando:
    ```julia
    (v1.3) pkg> add IJulia

    (v1.3) pkg> build IJulia

    (v1.3) pkg> add Weave Plots PyPlots GR
    ```


4. Iniciar el "Jupyter notebook": Regresamos ahora a la línea de comandos de
Julia (prompt `julia> `) usando la tecla para borrar o apretando `ctrl-C`. Para
empezar a usar el notebook, correremos los siguientes comandos:

    ```julia
    julia> using IJulia

    julia> notebook()
    ```

    A partir de aquí, uno puede ejecutar los comandos escritos en las celdas, y
    para ejecutarlos uno usa `shift-enter`.
