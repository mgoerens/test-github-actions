COMMIT_ID_LONG=$(shell git rev-parse HEAD)

.PHONY: bin
bin:
	CGO_ENABLED=0 go build \
		-ldflags "-X 'github.com/mgoerens/test_github_actions/cmd.CommitIDLong=$(COMMIT_ID_LONG)'" \
		-o ./out/test_github_actions main.go

