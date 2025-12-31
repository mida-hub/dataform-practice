# 本リポジトリについて
Google Cloud Dataform の検証用リポジトリです

# Dataform Core のバージョン
2.6.0

# ディレクトリ構成について
## Dataform 関連ファイル
- definitions
- includes
- dataform.json
- .df-credentials.json
- settings.json

### definitions　配下の構成について
- reporting: レポーティング用のデータセットを構築するためのスクリプトが格納されています
- sources: 外部データソースの定義が格納されています
- staging: ステージング用のデータセットを構築するためのスクリプトが格納されています

## コンテナ関連ファイル
- 上記以外はコンテナ関連のファイルです

```
├── definitions
│   ├── reporting
│   ├── sources
│   └── staging
├── includes
├── docker-compose.yaml
├── Dockerfile
├── dataform.json
├── node_modules
├── package-lock.json
├── package.json
├── README.md
└── settings.json
```

# Dataform の開発について
## 基本
### データソースを宣言する
外部データをデータソースとして宣言するには、definitions/sources 配下に .sqlx ファイルを作成し、以下のように記述します。
ファイル名は schema, name を利用して
definitions/sources/<schema>/<name>.sqlx としてください。

```
config {
  type: "declaration",
  schema: "dataset",
  name: "table"
}
```

### ステージングテーブルを作成する
データソースを利用して、クレンジングや型変換を行い、ステージングテーブルを作成するには、definitions/staging 配下に .sqlx ファイルを作成し、以下のように記述します。
ファイル名は schema, name を利用して
definitions/staging/<schema>/<name>.sqlx としてください。

```
config {
  type: "table",
  schema: "staging_dataset",
  name: "staging_table"
}
```

指示に応じて type: "table" を　view や incremental に変更してください。

### レポーティング用テーブルを作成する
ステージングテーブルを利用して、レポーティング用のテーブルを作成するには、definitions/reporting 配下に .sqlx ファイルを作成し、以下のように記述します。
ファイル名は schema, name を利用して
definitions/reporting/<schema>/<name>.sqlx としてください。

```
config {
  type: "table",
  schema: "reporting_dataset",
  name: "reporting_table"
}
```

## テーブルの参照について
Dataform では、他のテーブルを参照する場合に、ref 関数を利用します。
例えば、staging_dataset.staging_table を参照する場合は、以下のように記述します。

必ず、<schema>, <name> の順で指定してください。

```
select * from ${ref("staging_dataset", "staging_table")}
```
