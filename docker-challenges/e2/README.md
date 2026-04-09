1. ¿Cuánto pesa la imagen de la etapa builder vs la imagen de producción final? ¿Qué hay en la etapa builder que no está en producción?

El tamaño depende del caso, pero típicamente la imagen builder es más pesada porque incluye herramientas de build y dependencias completas, mientras que la de producción es más ligera porque solo tiene el runtime necesario. algunas de las cosas que tiene el builder que no tiene la producción son:
- Dependencias de desarrollo
- Archivos temporales de build
- Código fuente completo (a veces)
- Herramientas de compilación
- Caché de npm

Por otro lado el prod solo incluye:
- Código fuente necesario para ejecutar
- Algunas dependencias finales

mírese la imagen "tamaños.png" para la verificación del los tamaños.

2. ¿Cuándo es útil el flag --target al hacer docker build?

Se usa para construir hasta ciertas etapas, es decir detener la build.
Mírese la imagen "build-target.png". Los logs son más cortos.

3. ¿Qué diferencia hay entre ENV en Dockerfile y -e al ejecutar el contenedor? ¿Cuál tiene prioridad?

El parametro -e se utiliza para sobreescribir lo que esté en las variables de entorno, la línea de comandos tiene prioridad al ejecutar `docker run ...`

4. ¿Por qué se recomienda usar npm ci en lugar de npm install en entornos de CI/CD y producción?

El comando `npm ci` no modifica los archivos `package-lock.json`, ci realiza una instalación limpia (clean install), además no resulenve discrepancias con archivos, si hay un problema con los package*.json las build van a fallar, finalmente garantiza que la versión en producción sea identica a la de las pruebas y así evitar errores.

