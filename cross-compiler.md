 # build cross compiler


git clone https://github.com/richfelker/musl-cross-make.git

SnackLinux targets:
*
*
*

```
TARGET=aarch64-linux-musl make

TARGET=aarch64-linux-musl make install
```
## installs to `musl-cross-make/output/` 

`export PATH=$PATH:/path/to/out/bin`


# kernel



# on 32-bit x86
make bzImage

# on 64-bit x86
make zImage

# on 64-bit ARM
make Image





HOSTCFLAGS="-I/Users/easto/musl-cross-make/output//aarch64-linux-musl/include/" 

