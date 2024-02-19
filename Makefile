.PHONY: test

setup_githooks:
	git config core.hookspath .githooks

test:
	xcodebuild clean build test \
	-project ToDo-Garden/ToDo-Garden.xcodeproj \
	-scheme ToDo-Garden \
	-testPlan ToDo-GardenTestPlan \
	-enableCodeCoverage YES \
	-destination 'platform=iOS Simulator,OS=latest,name=iPhone 15 Pro' \
	-resultBundlePath ToDo-Garden.xcresult \
	| xcpretty -c;
