# dataform-practice
## 初期設定
```sh
$ dataform init bigquery . --default-database bigquery-practice-482713 --default-location US
$ dataform init-creds bigquery
```

## コンテナ
```sh
$ docker compose up -d
$ docker exec -it dataform bash
```
