# Material de clase

En este directorio encontrarán el material que hemos visto e iremos viendo en clase.
Los archivos típicamente estarán en formato `jmd`, que es un formato
en Markdown que incluye código y comandos en Julia. Este es un formato
más ligero que el `ipynb` y por lo mismo más sencillo de mantener, y lo reconoce plenamente la paquetería [`Weave.jl`](https://github.com/JunoLab/Weave.jl).

Para convertir un archivo de `jmd` a `ipynb`, y suponiendo
que iniciaron `Julia` desde este directorio, pueden hacer lo
siguiente:
```julia
julia> using Weave

julia> convert_doc("1-IntroJulia.jmd", "1-IntroJulia.ipynb")
```
Esto creará el archivo "1-IntroJulia.ipynb" en este directorio.
A partir de ahí, pueden seguir el notebook de la manera usual.
Si encuentran algún tipo de error o cosa que vale la pena
corregir, hagan la corrección directamente en el archivo `jmd` y
envíen un *pull request* para actualizar el repositorio de la clase.
