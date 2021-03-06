\* Copyright (c) 2012-2017 Bruno Deferrari.  All rights reserved.    *\
\* BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause *\

(define shen.quiet-load
  File -> (let Contents (read-file File)
            (map (/. X (shen.eval-without-macros X)) Contents)))

(define shen.run-shen
  [Exe "--script" Script | Args]
  -> (do (scm.initialize-shen)
         (set *argv* [Script | Args])
         (shen.quiet-load Script))
  Argv
  -> (do (scm.initialize-shen)
         (set *argv* Argv)
         (shen.shen)))
