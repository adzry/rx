
.PHONY: prod

prod:
	gh workflow run self-publish.yml
