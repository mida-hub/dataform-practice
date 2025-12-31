# 本リポジトリについて
Google Cloud Dataform の検証用リポジトリです

# Dataform Core のバージョン
2.6.0

# ディレクトリ構成について

```
├── definitions
│   ├── reporting
│   ├── sources
│   └── staging
├── includes
├── dataform.json
├── package.json
└── README.md
```

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

# Dataform の開発について
## 基本
### データソースを宣言する
外部データをデータソースとして宣言するには、definitions/sources 配下に .sqlx ファイルを作成し、以下のように記述します。
ファイル名は schema, name を利用して
definitions/sources/\<schema\>/\<name\>.sqlx としてください。

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
definitions/staging/\<schema\>/\<name\>.sqlx としてください。

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
definitions/reporting/\<schema\>/\<name\>.sqlx としてください。

```
config {
  type: "table",
  schema: "reporting_dataset",
  name: "reporting_table"
}
```

指示に応じて type: "table" を　view や incremental に変更してください。

## テーブルの参照について
Dataform では、他のテーブルを参照する場合に、ref 関数を利用します。
例えば、staging_dataset.staging_table を参照する場合は、以下のように記述します。

必ず、\<schema\>, \<name\> の順で指定してください。

```
select * from ${ref("staging_dataset", "staging_table")}
```


# コーディングガイドライン

## SQL スタイル
- 複雑なロジックは CTE (WITH 句) を使用して段階的に記述してください。
- SQL キーワード（select, from, where 等）は小文字で統一してください。
- インデントはスペース2つを使用してください。

## ドキュメント化と品質
- 指示の中にメタデータが共有された場合は、`config` ブロックに、そのテーブルの役割を示す `description` を必ず記述してください。重要なカラムには、`columns: { column_name: "説明" }` を記述してください。
- 一意性が保証されるべきカラムには `assertions: { uniqueKey: ["column_name"] }` を設定してください。

## パフォーマンス
- 抽出対象が巨大な場合は、`config` 内で BigQuery の `partitionBy` や `clusterBy` の設定を検討してください。書き方は以下の通りです。

```
config {
  type: "table",
  schema: "dataset",
  name: "table",
  bigquery: {
    partitionBy: "DATE(column_name)",  // 日付型のカラムでパーティション分割
    clusterBy: ["column1", "column2"]  // クラスタリングするカラム
  }
}
```

## includes の利用
現状、includes は未使用のため利用しません。
