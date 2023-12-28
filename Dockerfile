FROM nginx:latest

# Copiar el archivo de configuración personalizado
# COPY nginx.conf /etc/nginx/nginx.conf

# Copiar el contenido estático del sitio web
COPY ./build/web /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80