# Flutter architecture scripts generator

## Compilar script AOT 
 La compilación AOT genera un archivo en codigo maquina que se puede ejecutar unicamente en el sistema donde se compilo, eso quiere decir que el archivo compilado en mac no podra ser ejecutado en windows o linux tan solo en sistemas macOS.

```bash
 dart compile aot-snapshot bin/hybrid_widget_generator_script.dart -o ../build/hybrid_widget_generator_script
```

## Ejecutar scripts AOT

```bash
 dartaotruntime ../build/hybrid_widget_generator_script
```

## Desarrollo
El desarrollo y pruba de los scripts se haran desde la carpeta script_runner, esta carpeta contiene un proyecto de dart configurable para ejecutar los scripts con sus posibles dependencias.