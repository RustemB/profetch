NAME = profetch
TARGET = ./profetch

all: build test

build:
	gplc profetch.pl --no-top-level --no-debugger --no-fd-lib --no-fd-lib-warn --min-size -o profetch

test:
	$(TARGET)

install:
	install -Dm755 "$(TARGET)" "$(DESTDIR)/usr/bin/$(NAME)"

uninstall:
	rm -rfv "$(DESTDIR)/usr/bin/$(NAME)" "$(DESTDIR)/usr/share/licenses/$(NAME)"

clean:
	rm -v $(TARGET)
