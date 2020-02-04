
# `git`

## Instalación

Descargar la versión apropiada según la plataforma:

- OSX: https://git-scm.com/download/mac; otra alternativa es instalarlo a través
de [`homebrew`](https://brew.sh/)

- Linux: https://git-scm.com/download/linux

- Windows: https://gitforwindows.org/



<img src="https://raw.githubusercontent.com/louim/in-case-of-fire/master/in_case_of_fire.png" title="In case of fire (https://github.com/louim/in-case-of-fire)" width="280" height="200" align="center">

## ¿Qué es `git`?

`git` es un sistema de control de versiones descentralizado. Esto es, `git`
permite desarrollar proyectos colaborativos de manera coordinada, distribuida
(descentralizada), incremental y eficiente, guardando toda la historia del
proyecto en cada copia del proyecto.

`git` funciona desde la línea de comandos, aunque también existen versiones
gráficas.

## Configuración básica

Una vez instalado `git`, lo primero que haremos es configurarlo para que `git`
atribuya el trabajo de manera correcta. Para esto, desde la terminal,
ejecutaremos una serie de comandos:

```
    git config --global user.name "Su Nombre"

    git config --global user.email "usuario@email_de_verdad.hoy"

    git config --global color.ui "auto"

    git config --global github.user "Usuario_GitHub"
```


## `git` ultrabásico


Cualquier repositorio `git` consiste en tres "árboles" que justamente
son mantenidos por `git`.

- Primero, está el directorio de trabajo, donde se almacenan los archivos
relevantes del proyecto (e.g., `src/` o `./`).

+ Segundo, está el "índice" que es un área de almacenamiento previo a que se
hagan cambios.

* Finalmente, está el `HEAD` que apunta al último "commit" (cambio) hecho en
el proyecto.

### Flujo de trabajo

De manera totalmente abstracta ahora, el flujo de trabajo en `git` consiste en:

1. Hacer los cambios al proyecto, que se reflejan en el directorio de trabajo.
Típicamente, uno *crea* una rama para hacer los cambios, lo que permite no
alterar el estado de la rama maestra del proyecto.

- Añadir dichos cambios al "índice" (zona de almacenamiento temporal) usando
`git add <file>`. Nuevos cambios pueden ser realizados u otros archivos modificados
y añadidos a esta zona, sin que estos cambios individuales se reflejen en
el historial preciso del proyecto.

- Los cambios a uno o varios archivos del proyecto son incluidos en el historial
preciso del proyecto, actualizando el puntero `HEAD`. Esto se hace a través del
comando:
```
git commit -m "Mensaje descriptivo de los cambios realizados"
```

### Comandos básicos

Los comandos básicos para llevar a cabo el flujo del trabajo (local) son:

- `git help`

    Ayuda básica sobre `git`; en particular, despliega varios comandos útiles.
    Para obtener el manual correspondiente a cada comando se usa
    `git help <command>`.



- `git init`

    Sirve para inicializar cualquier repositorio local `git`. Este comando crea
    un directorio (`./.git/`) donde se almacena toda la información necesaria del
    repositorio.



- `git add <files>`

    Agrega el contenido del archivo a la lista de archivos (índice) cuyos
    cambios se seguirán en el repositorio.

- `git commit -m "Message about commit"`

    Este comando "compromete" los cambios hechos y agregados con `git add`, es
    decir, los incluye en el historial preciso del repositorio través de
    actualizar el puntero `HEAD`. La información que aquí se escribe es a la que
    se tiene acceso con `git log`.

- `git checkout`

    Este comando tiene varios usos relacionados con las ramas de desarrollo de un
    proyecto. La idea de las ramas (*branch*-es) es poder hacer cambios específicos
    sin alterar la versión principal del repositorio, o de manera independiente
    respecto a otros desarrolladores.

    - Permite cambiarse de rama a "mi_rama" usando
            git checkout <mi_rama>

    La rama principal por convención es la rama `master`.

    - Permite crear ramas, por ejemplo, podemos crear la rama "otra_rama", usando

            git checkout -b otra_rama

    - Permite revertir ciertos cambios en los archivos especificados. Por ejemplo,
    para revertir los cambios hechos en el archivo "mi_archivo" usamos:

            git checkout -- file


Los siguientes comandos permiten visualizar la historia del repositorio, o el
estado en que se encuentra el repositorio.

- `git log`

    Muestra la información sobre los commits que se han hecho en el repositorio,
    mostrando primero los commits más recientes.

    Existen varias formas útiles simplificadas, por ejemplo,

        git log --oneline
        git log --graph


- `git status`

    Muestra el estado del repositorio: por un lado, muestra la rama en la que se
    está trabajando, los cambios en los archivos (que se siguen) o la lista de
    archivos que no se están siguiendo, etc.

Los siguientes comandos son de interés a la hora de trabajar con versiones
remotas del repositorio, y son importantes para los aspectos colaborativos
de `git`.

- `git push`

    Este comando actualizará la versión remota de un repositorio local,
    "subiendo" los cambios hechos localmente.

- `git pull`

    Este comando actualizará la versión local de un repositorio, a partir de
    los cambios que hay en la dirección "remota" del repositorio.

- `git clone <repo remote address>`

    Permite crear una copia *local* de un repositorio remoto, que se especifica a
    través de su dirección. La copia local contiene el historial íntegro del
    repositorio remoto.

    A fin de contribuir a un proyecto remoto pero del cual no somos los
    "propietarios", por ejemplo, que está almacenado en `GitHub`, es indispensable
    hacer una copia propia del repositorio al que quieren contribuir en su cuenta
    de GitHub. Eso se hace desde GitHub, haciendo un "fork", es decir, creando una
    bifurcación del proyecto, donde ustedes harán sus cambios; eventualmente,
    podrán hacer una petición para que sus cambios puedan ser incluidos en el
    proyecto. Esto se hace a través de un *pull request*.


## `git` colaborativo

### Servidores remotos (*remotes*)

Uno debe tener claro que uno tiene una copia íntegra del repositorio en su disco
duro. El repositorio, además de estar en cada una las máquinas típicamente se
encuentra en un espacio "público" como GitHub (aunque el acceso puede ser
restringido!). `git clone` permite clonar un repositorio remoto a un directorio
local. De hecho, `git` permite seguir los cambios de distintos repositorios
remotos, por ejemplo, del proyecto oficial y de un "fork" propio de dicho proyecto.

Para ver qué configuración se tiene de los repositorios remotos, uno ejecuta

    git remote -v

Si uno quiere agregar un nuevo servidor remoto para seguir los cambios, por
ejemplo, el del fork propio, lo que se necesita hacer es usar el comando:

    git remote add <alias> <url_de_su_fork>

donde `<url_de_su_fork>` es la dirección donde está nuestro fork (en GitHub), y
`<alias>` es la abreviación que le daremos (por ejemplo, "fork" o "mifork").

La distinción entre el repositorio oficial y el fork, y por tanto sus abreviaciones
(o alias) son importantes: el proyecto oficial (digamos la clase) puede no ser de
nuestra propiedad, en el sentido de que no tenemos derecho a "empujar" los cambios,
mientras que el "fork" sí lo tenemos. Entonces, el comando

    git push mifork

empujará los cambios a `mifork`, y desde GitHub, podremos poner éstos a
consideración para que puedan ser incluidos en el repositorio oficial.

De igual manera, ustedes quieren tener actualizada la rama master de su fork con el
proyecto oficial. Lo que deben hacer para esto es:

    git checkout master
    git pull origin
    git push mifork

La primer instrucción hace el cambio a la rama "master", la segunda jala los
cambios (si es que hay en master) a la rama que tenemos localmente, y el último
actualiza nuestro fork en GitHub.

### Ramas

Un punto esencial para hacer de git una herramienta colaborativa es el uso de ramas (*branch*-es).

La idea es trabajar en una rama independiente, cosa que más o menos equivale a una
copia íntegra del lugar/momento (commit) en el que se crea la rama; esta
descripción es muy simplista dado que el trabajo en ramas es mucho más poderoso que
esto. En la rama uno hace un desarrollo específico, que eventualmente se envía para
ser considerado como nueva aportación en el proyecto.

Para crear una rama, uno puede usar el comando

    git branch <nombre_rama>

donde "nomre_rama" será el nomre de la nueva rama creada.

El comando anterior crea la rama, pero no nos cambia a esa rama. Para cambiarnos, utilizamos (ver arriba) el comando

    git checkout <nombre_rama>

Para ver qué ramas hay en el proyecto, uno usa el comando

    git branch -v

Una manera más corta de crear la rama y cambiarnos a ella es usar el comando

    git checkout -b <nombre_rama>

Es importante señalar que uno puede crear tantas ramas como se quiera y desde cualquier punto del desarrollo, dado que éstas son baratas en cuanto al espacio de disco. El commit en la rama desde el que se crea la nueva rama aparece en la nueva rama.



Algunas ligas útiles:

- [Learn git branching](https://learngitbranching.js.org/) Excelente!

- [Git - the simple guide](https://rogerdudler.github.io/git-guide/) Muy simplificada.

- [Git & GitHub Crash Course For Beginners](https://www.youtube.com/watch?v=SWYqp7iY_Tc) (video).
