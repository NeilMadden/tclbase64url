VERSION=1.0.1

all:
	cp base64url.tcl base64url-${VERSION}.tm

clean:
	rm -f base64url-*.tm
