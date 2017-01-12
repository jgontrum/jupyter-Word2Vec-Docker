.PHONY: clean start folders

all:
	virtualenv env -p python3.5 --no-site-packages
	env/bin/pip install --upgrade pip
	env/bin/pip install wheel
	env/bin/pip install -r requirements.txt
	env/bin/jupyter serverextension enable --py ipyparallel --user
	env/bin/jupyter nbextension install --py ipyparallel --user 
	env/bin/jupyter nbextension enable --py ipyparallel --user
	env/bin/python -m spacy.en.download all
	env/bin/python -m spacy.de.download all

clean:
	rm -rfv bin develop-eggs dist downloads eggs env parts
	rm -fv .DS_Store .coverage .installed.cfg bootstrap.py
	rm -fv logs/*.txt
	find . -name '*.pyc' -exec rm -fv {} \;
	find . -name '*.pyo' -exec rm -fv {} \;
	find . -depth -name '*.egg-info' -exec rm -rfv {} \;
	find . -depth -name '__pycache__' -exec rm -rfv {} \;

folders:
	mkdir -p /data/jupyter/notebooks
	touch /data/jupyter/auth

docker-build: clean
	docker-compose build --no-cache

docker-start: folders
	docker-compose up

start:
	env/bin/jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --notebook-dir ./notebooks

