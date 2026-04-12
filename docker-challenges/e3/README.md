
TODO:
- init.sql datos de pruebas
- flask app:
    - GET/            Contador de visitas (desde Redis)
    - GET/productos   Lista productos desde PostgreSQL
    - GET/health      Estado de conectividad con Redis y DB
- Preguntas
- descripción readme

## Preguntas de análisis
1. ¿Qué ocurre si eliminas el bloque depends_on con condition: service_healthy? ¿Cómo lo
verificarías?
2. ¿Cómo se resuelven los nombres de servicio (db, redis) como hostnames dentro de la red
Docker?
3. ¿Qué diferencia hay entre docker compose down y docker compose down -v?
4. ¿Cómo escalarías el servicio app a 3 instancias? ¿Qué limitaciones encontrarías con el puerto
publicado?
