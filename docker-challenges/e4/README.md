## Preguntas de análisis
1. ¿Por qué se recomienda usar Access Tokens en lugar de contraseñas para docker login?

Los Access Tokens puede tener fecha de expiración además de diferentes niveles de permisos, algunos son read-only por ejemplo. Se puede tener varios Access Tokens para diferentes casos de uso. Además si un agente externo roba algún token de acceso aún no podrá tener control total de la cuenta, dando tiempo para borrar ese token.

2. ¿Cuál es la diferencia entre docker push y docker pull? ¿Qué ocurre si intentas hacer push sin autenticarte?

docker push envía la imagen con su tag al repositorio, similar a git push, por otro lado docker pull se utiliza para obtener una imagen desde un repo.
Si se intenta hacer un push sin hacer previamente docker login, el comando mostrará un error diciendo que no se tienen permisos.

3. ¿Qué alternativas públicas existen a DockerHub (nombra al menos 2)? ¿Qué ventajas ofrecen frente a DockerHub?

1. Github packages, los repositorios de github puede hacer releases de packages, entre ellos imágenes. La ventaja es que está integrado con el propio código del software, haciendo posible buildear y publicar imágenes desde github actions por ejemplo. (similar a este es Gitlab Container Registry)
2. Amazon ECR (elastic container registry), La ventaja es la integración con los otros servicios de AWS.
3. Azure Container Registry, La ventaja, igual que con Amazon, es poder hacer deploys directamente.

