ifeq ($(OS),Windows_NT)
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif
OS =linux #default=linux
ifeq ($(detected_OS),Windows)
    OS =windows
endif
ifeq ($(detected_OS),Darwin)  # Mac OS X
    OS =osx
endif

all:
		$(MAKE) -f make/Makefile.${OS} all
debug:
		$(MAKE) -f make/Makefile-debug.${OS} all

clean:
		$(MAKE) -f make/Makefile.${OS} clean
		$(MAKE) -f make/Makefile-debug.${OS} clean

commit:
		-git add .
		-git commit
push: commit
		git push
release: push
		-git push
		-git tag $(shell git describe --tags --abbrev=0 | perl -lpe 'BEGIN { sub inc { my ($num) = @_; ++$num } } s/(v\d+\.\d+\.)(\d+)/$1 . (inc($2))/eg')
		-git push --tags
pull: commit
		git pull
