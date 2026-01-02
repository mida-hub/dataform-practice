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

## 権限
https://qiita.com/yuji0809/items/16287ca0559dda3f6f7b
