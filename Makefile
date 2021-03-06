BRANCH=$(shell git branch | grep '^*' | cut -d' ' -f2)
deploy: site.yaml clean content/media/images/blog/2012/openstack-swift-storage.png content/media/images/blog/2012/openstack-swift-replication.png
	hyde gen

pub: deploy
	if [ $(BRANCH) = "master" ]; then \
		if ! git status | egrep -q '^nothing to commit.*working directory clean'; then echo Untracked files, not pushing && exit 1; fi; \
		echo "==> RSYNC TO PROD"; \
		rsync -Pavz --delete deploy/ julien.danjou.info:/var/www/julien.danjou.info/; \
	else \
		echo "==> RSYNC TO DEV"; \
		rsync -Pavz --delete deploy/ julien.danjou.info:/var/www/dev.julien.danjou.info/; \
	fi

clean:
	rm -rf deploy
	rm -f content/blog/tags/*.html

web: deploy
	hyde serve -p 8080

content/media/images/blog/2012/openstack-swift-storage.png: content/blog/2012/openstack-swift-storage.ditaa
	ditaa --overwrite $< $@

content/media/images/blog/2012/openstack-swift-replication.png: content/blog/2012/openstack-swift-replication.ditaa
	ditaa --overwrite $< $@

.PHONY: clean web pub
