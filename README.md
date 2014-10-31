A self-sufficient Docker container to run simple Symfony applications.
Forked from ubermuda/symfony.

## Usage

```
$ docker run -itP \
    -v $PWD:/srv \
    -e DB_NAME=somedbname \
    -e INIT=bin/reload \
    hellslicer/symfony
```

## Parameters

Configuration is done through environment variables that you can change with `docker run`' s `-e` switch:

* `DB_NAME`, the database name. Defaults to `symfony`.
* `INIT`, path to a initialization script (eg: creating db tables, etc). Ignored if empty.