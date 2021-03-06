Shen/Scheme, a Scheme port of the Shen language
====================================================

* [Shen](http://shenlanguage.org)
* [chez-scheme](https://cisco.github.io/ChezScheme)
* [shen-scheme](https://github.com/tizoc/shen-scheme)

Shen is a portable functional programming language by [Mark Tarver](http://marktarver.com) that offers

- pattern matching,
- λ calculus consistency,
- macros,
- optional lazy evaluation,
- static type checking,
- an integrated fully functional Prolog,
- and an inbuilt compiler-compiler.

shen-scheme is a port of the Shen language that runs on top of Sheme implementations.

Right now the following implementations are supported:

* [chez-scheme](https://cisco.github.io/ChezScheme)

The following implementations were supported in version 0.15, but are not supported since version 0.16. Support may be added back in future releases.

* [chibi-scheme](http://synthcode.com/wiki/chibi-scheme)
* [gauche](http://practical-scheme.net/gauche/)

Building
--------

### Building from the source distribution

Running `make` should do the job. It will download and compile Chez under the `_build` directory, and then the `shen-scheme` binary and `shen.boot` boot files.

    make

### Building from scratch

This step is only necessary if cloning from this repository, the release tarballs include pregenerated `.scm` files.

To build from source, obtain a [copy of the Shen kernel distribution](https://github.com/Shen-Language/shen-sources/releases) and copy the `.kl` files to the `kl/` directory of shen-scheme. Then with a working Shen implementation do:

    (load "scripts/build.shen")
    (build program "shen-scheme.scm")

This will produce `.scm` files in the `compiled/` directory and a `shen-scheme.scm` file in the current directory.

After doing this the procedure is the same as building from the source distribution.

Running
-------

`shen-scheme` will start the Shen REPL. `shen-scheme --script <some shen file>` will run a script.

Boot file search path
---------------------

If the environment variable `SHEN_BOOTFILE_PATH` has a value, it will be used as the path to the boot file to load.
If not, it will be searched on at the location defined by the compile-time variable `DEFAULT_BOOTFILE_PATH`.
If the value of `DEFAULT_BOOTFILE_PATH` is `NULL`, then a `shen.boot` file placed at the same directory as the `shen-scheme` executable will be loaded.

Native Calls
------------

Scheme functions live under the `scm` namespace (`scm.` prefix). For example: `(scm.write [1 2 3 4])` invokes Scheme's `write` function with a list as an argument.

Because Scheme functions can have variable numbers of arguments and the code passed to `scm.` is not preprocessed, any imported function that is intended to support partial application has to be wrapped with a `defun`:

```
(0-) (defun my-for-each (F L) (scm.for-each F L))
my-for-each

(1-) (my-for-each (/. X (do (print (+ X X)) (nl))) [1 2 3 4 5])
2
4
6
8
10
0

(2-) (my-for-each (function print))
#<procedure>
```

Importing bindings from Scheme modules
--------------------------------------

[import expressions](https://cisco.github.io/ChezScheme/csug9.5/libraries.html#./libraries:h4) are supported through the `scm.` prefix. Names will be imported under the `scm.` namespace.

Example:

    (1-) (scm.import (rename (rnrs) (+ add-numbers)))
    #<void>

    (2-) (scm.add-numbers 1 2 3 4)
    10

License
-------

- Shen, Copyright © 2010-2015 Mark Tarver - [License](http://www.shenlanguage.org/license.pdf).
- shen-scheme, Copyright © 2012-2017 Bruno Deferrari under [BSD 3-Clause License](http://opensource.org/licenses/BSD-3-Clause).
