include makefiles/gitignore.mk
include makefiles/rq.mk
include makefiles/help.mk
include makefiles/dynamodb-local.mk

################################################################################
# 変数
################################################################################

################################################################################
# マクロ
################################################################################

################################################################################
# タスク
################################################################################
.PHONY: up
up:
	docker-compose up

.PHONY: down
down:
	docker-compose down
