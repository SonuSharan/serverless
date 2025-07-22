ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

Root:
	echo $(ROOT_DIR)

buildNode:
	npm install\
	node build.js

deployConfig:
	aws s3 cp ./config/config-dev.json s3_bucket_name/config/config.json

compressExtractUnix:
	cd ./dist && \
	zip -r serverless.zip src/lambda/serverless.js

compressProcessUnix:
	cd ./dist && \
	zip -r process.zip src/lambda/process.js

compressExtractWin:
	cd ./dist && \
	powershell New-Item -ItemType Directory -Path './extract/src/lambda' -Force && \
			powershell Copy-Item -Path ./src/lambda/extract.js -Destination ./extract/src/lambda/extract.js && \
				powershell Compress-Archive -Path ./extract/src -DestinationPath ./extract -Force && \
					powershell Remove-Item './extract' -Recurse

compressProcessWin:
	cd ./dist && \
	powershell New-Item -ItemType Directory -Path './process/src/lambda' -Force && \
			powershell Copy-Item -Path ./src/lambda/process.js -Destination ./process/src/lambda/process.js && \
				powershell Compress-Archive -Path ./process/src -DestinationPath ./process -Force && \
					powershell Remove-Item './process' -Recurse

deployExtractLambda:
	if aws lambda get-function --function-name exserverlesstract-dev > /dev/null 2>&1; then \
        echo "Updating Lambda function..."; \
        aws lambda update-function-code \
			--function-name serverless-dev \
			--zip-file fileb://./dist/serverless.zip; \
    else \
        echo "Creating new Lambda function..."; \
        aws lambda create-function \
			--function-name serverless-dev \
			--region us-west-2 \
			--runtime nodejs20.x \
			--handler src/lambda/serverless.handler \
			--role arn:aws:iam::205234592526:role/Lambda-Execution-Role-dev \
			--timeout 300 --memory-size 1024 \
			--environment Variables="{LOG_LEVEL = info, NODE_OPTIONS = --enable-source-maps, PSIC_ENV = dev, BUCKET_NAME = process-common-bucket, CONFIG_PATH = config/config.json}"\
			--zip-file fileb://./dist/serverless.zip; \
    fi