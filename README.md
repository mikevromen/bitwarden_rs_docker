# bitwarden rs in docker

## Run

### Generate keys & certificates

Execute the command below
```bash
./createCerts.sh device_ip_address
```
### Start & run the containers
```bash
docker-compose up -d
```

## Additional configuration
You might want to edit the backup frequency in the docker-compose.yml by changes the value **CRON_TIME**