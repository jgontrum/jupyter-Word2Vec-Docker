FROM python:3.5
MAINTAINER Johannes Gontrum <gontrum@me.com>

# Install the needed packages
RUN apt-get update
RUN apt-get install -y supervisor nginx

# Copy and set up the app
RUN mkdir /app
RUN mkdir /app/config
RUN mkdir /app/notebooks
COPY config/nginx.conf /etc/nginx/sites-available/default
COPY config/supervisor.conf /etc/supervisor/conf.d/
COPY config/jupyter_notebook_config.py /app/config/
COPY Makefile /app/
COPY requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install virtualenv
RUN cd /app && make

RUN echo "daemon off;" >> /etc/nginx/nginx.conf 

EXPOSE 40010
CMD ["supervisord", "-n"]

