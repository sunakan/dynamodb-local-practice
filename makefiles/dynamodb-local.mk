################################################################################
# 変数
################################################################################
DYNAMO_ENDPOINT_URL := http://localhost:8000
DYNAMO_TABLE_NAME   := ResourceTable
DYNAMO_PK_NAME      := PK
DYNAMO_SK_NAME      := SK

################################################################################
# マクロ
################################################################################

################################################################################
# タスク
################################################################################
.PHONY: list-tables
list-tables: ## dynamodb tableの一覧
	aws dynamodb list-tables --endpoint-url $(DYNAMO_ENDPOINT_URL)

# --table-name 'ResourceTable'というテーブル名で、
# --attribute-definitions 文字列の'PK'と'SK'値を持ち、
# --key-schema 'PK'をパーティションキー、'SK'をソートキー
# --provisioned-throughput １秒間に５回の読み込みと書き込みができます（デフォルト）
.PHONY: create-table
create-table: ## dynamodb tableの作成
	aws dynamodb create-table \
		--table-name $(DYNAMO_TABLE_NAME) \
		--attribute-definitions AttributeName=$(DYNAMO_PK_NAME),AttributeType=S AttributeName=$(DYNAMO_SK_NAME),AttributeType=S \
		--key-schema AttributeName=$(DYNAMO_PK_NAME),KeyType=HASH AttributeName=$(DYNAMO_SK_NAME),KeyType=RANGE \
		--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
		--endpoint-url $(DYNAMO_ENDPOINT_URL) \
	| jq '.'

.PHONY: describe-table
describe-table: ## dynamodb tableの詳細
	aws dynamodb describe-table \
		--table-name $(DYNAMO_TABLE_NAME) \
		--endpoint-url $(DYNAMO_ENDPOINT_URL) \
	| jq '.'

# --table-name 'ResourceTable' というテーブルに新しいデータを
# --item パーティションは'taro'、ソートキーは'taro@example.com'という内容でput
.PHONY: put-item
put-item: ## dynamodb サンプルデータを入れる
	aws dynamodb put-item \
		--table-name $(DYNAMO_TABLE_NAME) \
		--item '{"PK": {"S": "taro"}, "SK": {"S": "taro@example.com"}}' \
		--endpoint-url $(DYNAMO_ENDPOINT_URL)

.PHONY: scan ## dynamodb サンプルデータを入れる
scan: ## dynamodb データ一覧
	aws dynamodb scan \
		--table-name $(DYNAMO_TABLE_NAME) \
		--endpoint-url $(DYNAMO_ENDPOINT_URL) \
	| jq '.'
