# terraform-env

## AWS
```shell
cp example.env .env
```

```shell
vi .env
```

```shell
. ./setup_env.sh
```

```shell
cd aws/us-east-2/use2-demo-1
```

```shell
terragrunt init --all
```

```shell
terragrunt apply --all
```

## GCP
```shell
cp example.env .env
```

```shell
vi .env
```

```shell
. ./setup_env.sh
```

### Create VPC
```shell
cd gcp/us-central1/dev/vpc
```

```shell
terragrunt init
```

```shell
terragrunt apply
```

### Create GKE
```shell
cd gke
```

```shell
terragrunt init
```

```shell
terragrunt apply
```

### Configure GKE and Deploy Redis
```shell
cd ../apps/gke_env/
```

```shell
terragrunt init --all
```

```shell
terragrunt apply --all
```
