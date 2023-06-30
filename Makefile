LIBS := libpuppy.a libpuppy.so

.PHONY: all
all: $(LIBS)

libpuppy.a: libpuppy.nim
	nim c --noMain --app:staticlib -d:release -o:libpuppy.a $<

libpuppy.so: libpuppy.nim
	nim c --noMain --app:lib -d:release -o:libpuppy.so $<

.PHONY: clean
clean:
	find . -type f \( -name '*.so' -o -name '*.a' \) -delete

.PHONY: install-deps
install-deps:
	nimble install puppy
