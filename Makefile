phony: build
build:
	mkdir -p dist/
	cp requirements.txt dist/
	cp pydoro/* dist/
	zip -jr dist.zip dist/

phony: clean
clean:
	rm -rf dist.zip dist

phony: upload
upload:
	aws s3api put-object \
		--bucket dm-pydoro-packages \
		--key "pydoro/${{ github.sha }}.zip" \
		--body ./frontend.zip
