# mongodb-gc-backup

A Docker image for performing MongoDB backups to Google Cloud Storage

## MongoDB version support

Up to 4.4.

## Usage

### Run via Docker

```
docker run \
 -e MONGODB_HOST=<db host> \
 -e MONGODB_DB=<your db name> \
 -e MONGODB_USER=<your db username> \
 -e MONGODB_PASSWORD=<your secret> \
 -e GCS_KEY_FILE_PATH=<path to GC service account key file> \
 -e GCS_BUCKET=<GC bucket name>
 dazlabteam/mongodb-gc-backup
```

### Run via Docker Compose

Edit your Docker Compose file, add new `backup` service:

```
  db:
    image: "mongo:4.4.6"
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: secret
      MONGO_INITDB_DATABASE: demo

  ...

  backup:
    image: dazlabteam/mongodb-gc-backup
    environment:
      MONGODB_HOST: db
      MONGODB_DB: demo
      MONGODB_USER: root
      MONGODB_PASSWORD: secret
      GCS_KEY_FILE_PATH: <path to GC service account key file>
      GCS_BUCKET: <GC bucket name>
```

Then run

```
docker-compose -f <path to docker compose yaml> run --rm backup
```

or by specifying env variables via the command line:

```
docker-compose -f <path to docker compose yaml> run --rm \
 -e MONGODB_HOST=<db host> \
 -e MONGODB_DB=<your db name> \
 -e MONGODB_USER=<your db username> \
 -e MONGODB_PASSWORD=<your secret> \
 -e GCS_KEY_FILE_PATH=<path to GC service account key file> \
 -e GCS_BUCKET=<GC bucket name> \
 backup
```

### Schedule inside Kubernetes Cluster

Create Kubernetes secret containing all the environment variables:

```
kubectl create secret generic mongodb-gc-backup \
 --from-literal=MONGODB_HOST=<db host> \
 --from-literal=MONGODB_DB=<your db name> \
 --from-literal=MONGODB_USER=<your db username> \
 --from-literal=MONGODB_PASSWORD=<your secret> \
 --from-literal=GCS_KEY_FILE_PATH=<path to GC service account key file> \
 --from-literal=GCS_BUCKET=<GC bucket name>
```

then create CronJob using the cronjob spec file from this repo:

```
kubectl apply -f mongodb-gc-backup.cronjob.yaml
```

By default, it will run every day at 00:00. To change this, edit cronjob and specify other schedule:

```
kubectl edit cronjob mongodb-gc-backup
```

## License

MIT

## Links

- https://hub.docker.com/r/dazlabteam/mongodb-gc-backup
- https://github.com/takemetour/docker-mongodb-gcs-backup
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
- https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
 