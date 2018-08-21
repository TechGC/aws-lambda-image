.PHONY: clean configtest

lambda:
	@npm install .
	@echo "Factory package files..."
	@if [ ! -d build ] ;then mkdir build; fi
	@if [ ! -d upload ] ;then mkdir upload; fi
	@cp index.js build/index.js
	@cp config/${TARGET}.json build/config.json
	@if [ -d build/node_modules ] ;then rm -rf build/node_modules; fi
	@cp -R node_modules build/node_modules
	@cp -R lib build/
	@cp -R bin build/
	@rm -rf build/bin/darwin
	@echo "Create package archive..."
	@cd build && zip -rq ${TARGET}.zip .
	@mv build/${TARGET}.zip upload/

uploadlambda: lambda
	aws lambda update-function-code --function-name ${FUNCTION} --zip-file fileb://upload/${TARGET}.zip --profile techgc --region us-east-2

configtest:
	@./bin/configtest ${TARGET}

clean:
	@echo "Cleaning up bundle files & node_modules done."
	@if [ -d build ]; then rm -rf build; fi
	@if [ -d upload ]; then rm -rf upload; fi
	@if [ -d node_modules ]; then rm -rf node_modules; fi
