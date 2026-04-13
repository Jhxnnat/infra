# Aplicación Multi-Servicio

Aplicación web completa con cuatro servicios interconectados: un backend y frontend Flask, una base de datos PostgreSQL, un caché Redis y un reverse-proxy Nginx.

## Preguntas de análisis
1. ¿Qué ocurre si eliminas el bloque depends_on con condition: service_healthy? ¿Cómo lo verificarías?

Al no tener el depends_on no se garantiza que la app de flask inicie después de redis y postgres, lo cuál es inconveniente porque la aplicación los necesita.
Esto se podría manejar haciendo que la aplicación flask maneje errores con execpciones cuando no se puede connectar a los servicios.

2. ¿Cómo se resuelven los nombres de servicio (db, redis) como hostnames dentro de la red Docker?

Por la redes definias en el compose, si varios servicios están declarados para pertenecer a la misma red, el dns de docker puede resolver los hostnames para no tener que usar ip.

3. ¿Qué diferencia hay entre docker compose down y docker compose down -v?

La opción -v se utiliza para que al detener los contenedores se borre los volúmenes que se encuentra en los directorios declarados en la sección 'volumes' del compose, también elimina los volúmenes anónimos.

4. ¿Cómo escalarías el servicio app a 3 instancias? ¿Qué limitaciones encontrarías con el puerto publicado?

La CLI de docker tiene la opción de hacer replicas de una aplicación con el comando `docker service scale SERVICE=REPLICAS`, en este caso el comando sería `docker service scale app=3`.
Cuando se ejecuta `docker ps` la información de escalado se puede ver en la columna de 'REPLICAS'.
Un problema es que no se sabe de manera determinista el puerto que las replicas van a tener. En ese caso es posible que se deba usar rangos para los puertos, aunque para esto es posible que se deba cambiar cómo están declaradas algunas configuraciones.

