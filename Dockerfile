FROM python:3.5
MAINTAINER Johannes Gontrum <gontrum@me.com>

# Install the needed packages
RUN apt-get update
RUN apt-get install -y supervisor nginx

# Copy and set up the app
RUN mkdir /app
RUN pip install virtualenv
RUN mkdir -p ~/.jupyter
COPY jupyter_notebook_config.py ~/.jupyter/
COPY config /app/
COPY Makefile /app/
COPY requirements.txt /app/
COPY notebooks /app/
RUN cd /app && make

# Configure nginx
RUN mv /app/config/nginx.conf /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf 

# Configure supervisor
RUN mv /app/config/supervisor.conf /etc/supervisor/conf.d/

EXPOSE 40010
CMD ["supervisord", "-n"]

