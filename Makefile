build: profetch.pl
	gplc profetch.pl --no-top-level --no-debugger --no-fd-lib --no-fd-lib-warn --min-size -o profetch

clean:
	rm profetch
