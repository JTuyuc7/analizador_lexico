# Documentacion
### Universidad Mariano Galvez de Guatemala
#### Automatas y Lenguajes formales
#### Seccion "B"

El proyecto usa un analizador lexico para poder validar cadenas de texto, que, para este caso se validan fechas cortas en los siguientes formatos.

``` 
15/09/2024 – FECHA_CORTA_NUMEROS
2/08/2024 – FECHA_CORTA_NUMEROS
05-10-2023 – FECHA_CORTA_NUMEROS
2024.12.31 – FECHA_CORTA_NUMEROS
25/12/2023 – FECHA_CORTA_NUMEROS
01-01-2021 – FECHA_CORTA_NUMEROS
2021.11.11 – FECHA_CORTA_NUMEROS
31/01/2022 – FECHA_CORTA_NUMEROS
2020.01.01 – FECHA_CORTA_NUMEROS
28-02-2024 – FECHA_CORTA_NUMEROS
```
## Como funciona?
El proyecto esta dividido de la siguiente manera
```
Proyecto_expresiones_regulares
---.idea
---out
---src
------DateFlexer.flex
------DateLexer.java (archivo generado dinamicamente)
------test.txt (archivo de pruebas)
------UI (Clase Principal)
---.gitignore
---Proyecto_expresiones_regulares.iml
---README.md
```
[DateFlexer.flex](src/DateFlexer.flex) Es el archivo donde se tiene la logica para poder generar las reglas y las validaciones necesarias que se encargaran de validar en el archivo de entrada `txt` y poder retornar las coincidencias.

## Como genero la clase?
Para poder generar la clase [DateLexer.java](src/DateLexer.java) este es un archivo dinamico que se genera al realizar la compilacion del archivo `.flex`, para eso necesitamos el `jar` file de `jflex` [descargar jflex](https://jflex.de/download.html) para este ejemplo lo configuraremos usando el editor de codigo `intelliJ` para esto necesitamos seguir los siguientes pasos.
* 