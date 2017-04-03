CONTAINERS=`docker ps -a -q`
IMAGES=`docker images -q`

# pull the tag from version.py
TAG=`cat version.py | grep '__version__ = ' | sed -e 's/__version__ = //g' | sed -e "s/'//g"`
WORKERIMAGE=lcmap-pyccd-worker:$(TAG)

vertest:
	echo $(TAG)
	echo $(WORKERIMAGE)

docker-build:
	docker build -t $(WORKERIMAGE) $(PWD)

docker-shell:
	docker run -it --entrypoint=/bin/bash usgseros/$(WORKERIMAGE)

docker-deps-up:
	docker-compose -f resources/docker-compose.yml up -d

docker-deps-up-nodaemon:
	docker-compose -f resources/docker-compose.yml up

docker-db-test-schema:
	docker cp test/resources/test.schema.setup.cql worker-cassandra:/
	docker exec -u root worker-cassandra cqlsh localhost -f test.schema.setup.cql

docker-deps-down:
	docker-compose -f resources/docker-compose.yml down

deploy-pypi:

deploy-dockerhub:

clean-venv:
	@rm -rf .venv

clean:
	@rm -rf dist build lcmap_pyccd_worker.egg-info
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -delete
