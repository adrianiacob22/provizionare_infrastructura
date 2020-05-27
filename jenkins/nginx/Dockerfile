FROM nginx:1.17.9
# Folosesc o imagine nginx cu o versiune specifica pentru ca vreau sa ma asigur
# ca nu este nevoie sa schimb configuratia serverului functie de versiune.
LABEL maintainer="adrianiacob22@gmail.com"
ENV nginx_conf /etc/nginx/conf.d/

## Sterg configuratia de nginx existenta in container
RUN rm /etc/nginx/conf.d/default.conf

# Adaug configuratie nginx specifica pentru nevoile proiectului.
# Fisierele de configurate sunt copiate in imagine.
# Orice modificare va fi facuta in acestea in timp ce containerul ruleaza,
# va fi pierduta la repornirea containerului.
COPY conf/jenkins.conf ${nginx_conf}
COPY conf/nginx.conf /etc/nginx/

# Expun porturile 80 si 443 in exteriorul containerului.
EXPOSE 80 443
CMD ["nginx"]
