# BOSH release for cf-containers-broker

This BOSH release and deployment manifest deploy a cluster of cf-containers-broker.

## Dynamically provision containers via Open Service Broker API

This BOSH release includes a `cf-containers-broker` job provides an API that can provision new Docker containers running PostgreSQL/MySQL/Redis/whatever on demand. The API is [Open Service Broker API](https://www.openservicebrokerapi.org/) compatible, which means you can register it with Cloud Foundry, Kubernetes and more.

Allow users to dynamically provision persistent services, running in Docker containers, using the `cf` Cloud Foundry CLI:

![cf-create-service-ctop](manifests/broker/cf-create-service-ctop.gif)

The example usage is MySQL 5.6: each provisioned service is running inside a dedicated Docker container. The service provides credentials that look like:

```
$ cf create-service mysql56 free mysql1
$ cf create-service-key mysql1 mysql1-key
$ cf service-key mysql1 mysql1-key
{
 "dbname": "wcfh1voergicdt9n",
 "hostname": "10.244.33.0",
 "password": "mlasvy5fpq9zx8mb",
 "port": "32770",
 "ports": {
  "3306/tcp": "32770"
 },
 "uri": "mysql://duawbyody1ashrgr:mlasvy5fpq9zx8mb@10.244.33.0:32770/wcfh1voergicdt9n",
 "username": "duawbyody1ashrgr"
}
```

See [docker-broker-deployment](https://github.com/cloudfoundry-community/docker-broker-deployment) for a dedicated repo that is all about deploying an Open Service Broker API compatible cluster that runs your favourite services inside on-demand Docker containers.

This repo is similar/same as `manifests` folder, which is used for the CI test harness.

## Usage

This repository includes base manifests and operator files. They can be used for initial deployments and subsequently used for updating your deployments:

```
export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=cf-containers-broker
git clone https://github.com/cloudfoundry-community/cf-containers-broker-boshrelease.git
bosh deploy cf-containers-broker-boshrelease/manifests/cf-containers-broker.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/redis32.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/postgresql96.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/mysql56.yml

bosh run-errand sanity-test
```

If your BOSH does not have Credhub/Config Server, then remember `--vars-store` to allow generation of passwords and certificates.

### Update

When new versions of `redis-boshrelease` are released the `manifests/cf-containers-broker.yml` file will be updated. This means you can easily `git pull` and `bosh deploy` to upgrade.

```
export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=cf-containers-broker
cd cf-containers-broker-boshrelease
git pull
cd -
bosh deploy cf-containers-broker-boshrelease/manifests/cf-containers-broker.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/redis32.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/postgresql96.yml \
  -o cf-containers-broker-boshrelease/manifests/operators/services/mysql56.yml

bosh run-errand sanity-test
```
