\* Copyright (c) 2012-2017 Bruno Deferrari.  All rights reserved.    *\
\* BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause *\

(load "src/compiler.shen")

(assert-equal
 (_scm.force-boolean true)
 true)

(assert-equal
 (_scm.force-boolean false) false)

(assert-equal
 (_scm.force-boolean [number? 1])
 [number? 1])

(assert-equal
 (_scm.force-boolean [+ 1 2])
 [_scm.assert-boolean [+ 1 2]])

(assert-equal
 (_scm.force-boolean [let X 1 [number? X]])
 [let X 1 [number? X]])

(assert-equal
 (_scm.force-boolean [let X 1 [+ X X]])
 [_scm.assert-boolean [let X 1 [+ X X]]])

(assert-equal
 (_scm.force-boolean [and true false])
 [and true false])

(assert-equal
 (_scm.prefix-op test)
 (intern "kl:test"))

\\ compile-expression

(assert-equal
 (_scm.kl->scheme [])
 [quote []])

(assert-equal
 (_scm.kl->scheme true)
 true)

(assert-equal
 (_scm.kl->scheme false)
 false)

(assert-equal
 (_scm.kl->scheme {)
 [quote {])

(assert-equal
 (_scm.kl->scheme })
 [quote }])

(assert-equal
 (_scm.kl->scheme ;)
 [quote ;])

(assert-equal
 (_scm.kl->scheme some-symbol)
 [quote some-symbol])

(assert-equal
 (_scm.kl->scheme [let A 1 [+ A A]])
 [let [[A 1]] [+ A A]])

(assert-equal
 (_scm.kl->scheme [lambda X [= X 1]])
 [lambda [X] [(_scm.prefix-op =) X 1]])

(assert-equal
 (_scm.compile-expression [and [some-func X] [= 1 2]] [X])
 [and [(_scm.prefix-op _scm.assert-boolean) [(_scm.prefix-op some-func) X]] [(_scm.prefix-op =) 1 2]])

(assert-equal
 (_scm.compile-expression [or [some-func X] [= 1 2]] [X])
 [or [(_scm.prefix-op _scm.assert-boolean) [(_scm.prefix-op some-func) X]] [(_scm.prefix-op =) 1 2]])

(assert-equal
 (_scm.kl->scheme [trap-error [+ 1 2] [lambda E 0]])
 (cases
  (= (implementation) "gambit-scheme")
  [with-exception-catcher
   [lambda [E] 0]
   [lambda [] [+ 1 2]]]

  true
  [let [[?handler [lambda [E] 0]]]
    [guard [?exn [else [?handler ?exn]]]
      [+ 1 2]]]))

(assert-equal
 (_scm.kl->scheme [do 1 2])
 [begin 1 2])

(assert-equal
 (_scm.kl->scheme [freeze [print "hello"]])
 [lambda [] [(_scm.prefix-op print) "hello"]])

(assert-equal
 (_scm.kl->scheme [fail])
 [(_scm.prefix-op fail)])

(assert-equal
 (_scm.kl->scheme [blah 1 2])
 [(_scm.prefix-op blah) 1 2])

(assert-equal
 (_scm.kl->scheme 1)
 1)

(assert-equal
 (_scm.kl->scheme "string")
 "string")

(assert-equal
 (_scm.kl->scheme [defun some-name [A B C] [cons symbol [+ A B]]])
 [begin
  [define [(_scm.prefix-op some-name) A B C] [cons [quote symbol] [+ A B]]]
  [quote some-name]])

(assert-equal
 (_scm.compile-expression [F 1 2 3] [F])
 [[[F 1] 2] 3])

(assert-equal
 (_scm.kl->scheme [+ 1])
 [[lambda [Y] [lambda [Z] [+ Y Z]]] 1])

(define takes-3-args
  X Y Z -> X)

(define takes-0-args -> 0)

(assert-equal
 (_scm.compile-expression [takes-3-args A B] [A B])
 [[[lambda [X] [lambda [Y] [lambda [Z] [(_scm.prefix-op takes-3-args) X Y Z]]]] A] B])

(assert-equal
 (_scm.compile-expression [takes-3-args X Y Z symbol W] [X Y Z W])
 [[[(_scm.prefix-op takes-3-args) X Y Z] [quote symbol]] W])

(assert-equal
 (_scm.kl->scheme [takes-0-args])
 [(_scm.prefix-op takes-0-args)])

(assert-equal
 (_scm.kl->scheme [takes-0-args 1])
 [[(_scm.prefix-op takes-0-args)] 1])

(assert-equal
 (_scm.kl->scheme [takes-?-args])
 [(_scm.prefix-op takes-?-args)])

(assert-equal
 (_scm.kl->scheme [takes-?-args 1 2 3])
 [(_scm.prefix-op takes-?-args) 1 2 3])
