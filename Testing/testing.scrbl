#lang scribble/doc
@(require scribble/manual)
@(require "../my-utils.rkt")

@;(enable-sh)

@title[#:tag "testing"]{Testing}

프로그램을 개발하는데 있어, TDD(Test Driven Development) 방법론은, 테스트와 프로그램 개발을
병행함으로써, 이미 작성된 모든 프로그램 코드의 무결성을 그때 그때 확인해 가며 개발을 진행할
수 있기 때문에, 나중에 발견될 수도 있는 버그 처리 과정을 미리 방지하게 해 준다. 아울러
테스트 코드 자체가 프로그램 코드의 훌륭한 실행 예제를 제공하므로, 해당 API의 문서화의
효과도 볼 수 있다.

언뜻 생각하기에는, 프로그램 코드와 테스트 코드를 둘 다 작성하다 보면, 시간이 더 걸리는 것
아니냐는 생각을 할 수도 있는데, 실제의 경험상으로는 그 반대다. 테스트 코드를 작성하며
코딩을 진행하면, 본 코드를 작성할 때 테스트를 염두에 두고 코드를 짜게 된다. 그 결과
테스트에 용이한 보다 단순하고 논리적인 코드를 작성하게 되어, 프로그램의 유지/보수에 더
용이한 생산적인 코드를 낳게 된다. 아울러 코드를 개선할 때마다 테스트 코드를 실행함으로써,
이전에 작성한 모든 코드들과의 호환성을 미리 검증하는 과정을 매번 거치치 되므로, 버그를
미연에 방지해 주는 효과까지 곁들어지게 되어, 결과적으로는 프로젝트를 더 짧은 시간 안에
완료할 수 있게 해 즌다. 코딩하는 시간보다 디버깅하는 시간이 훨씬 더 많이 든다는 것을 이미
경험해 본 프로그래머라면 위의 주장이 쉽게 납득되리라 본다.

Clojure는 TDD(Test Driven Development)를 지원하는 기능이 이미 @tt{clojure.test} 패키지에
내장되어 있다.

@index['("deftest" "macro" "clojure.test")]
@index['("is" "macro" "clojure.test")]
@section{deftest 매크로 & is 매크로}

@descblock|{
(deftest name & body)      <macro>   [clojure.test]
  name -- test name을 지정한다.
  body -- 실제 test 코드가 작성되는 자리.

(is predicate)             <macro>   [clojure.test]
(is predicate message)
  predicate -- 참 또는 거짓을 반환하는 form.
  message -- predicate이 거짓을 반환할 경우, 출력할 메시지.
}|

대부분의 테스트 코드는 @tt{deftest} 매크로와 @tt{is} 매크로를 이용해 작성한다.  @tt{is}
매크로는, 테스트 실패시 출력할 메시지를, 두 번째 인수에 지정할 수도 있다.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(deftest add
  (is (= 4 (+ 2 2)))
  (is (= 2 (+ 2 0)) "adding zero doesn't change value"))
}|

@tt{lein test} 명령을 내리면, @tt{test/myproject/test/} 폴더 아래의 모든 테스트 파일들을
읽어 들여 실행한다. 각 테스트 파일 안의 모든 @tt{deftest} 문의 @tt{body} 부분을
실행한 후, 그 결과를 보고한다.

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
Ran 1 tests containing 2 assertions.
0 failures, 0 errors.
}|

위에서는 test 1건, assertion 2건을 처리해 실패 0건, 에러 0건이 발생했음을 보고하고 있다.

이번에는 의도적으로 테스트 실패를 유도해 보자.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(deftest add
  (is (= 4 (+ 2 2)))
  (is (= 2 (+ 2 0)) "adding zero doesn't change value")
  (is (= 9 (+ 4 4)))                            ; error here
  (is (= 7 (+ 2 4)) "2 + 4 should return 6"))   ; error here
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
FAIL in (add) (core.clj:8)
expected: (= 9 (+ 4 4))
  actual: (not (= 9 8))
FAIL in (add) (core.clj:9)
2 + 4 should return 6
expected: (= 7 (+ 2 4))
  actual: (not (= 7 6))
Ran 1 tests containing 4 assertions.
2 failures, 0 errors.
}|


@index['("are" "macro" "clojure.test")]
@section{are 매크로}

@descblock|{
(are argv expr & args)     <macro>   [clojure.test]
}|

@tt{clojure.test}는 @tt{is} 매크로 외에도 @tt{are} 매크로를 제공한다. 이름을 통해 예상할 수
있겠지만, 하나의 @tt{are} 매크로는 여러 개의 @tt{is} 매크로를 대신할 수 있다.

방금 전에 든 예를, @tt{are} 매크로를 사용해 재작성해 보면 다음과 같다.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(deftest add
  (are [sum x y] (= sum (+ x y))
        4 2 2
        2 2 0
        9 4 4
        7 2 4))
}|

즉, @tt{sum}에 4, @tt{x}에 2, @tt{y}에 2가 각각 대입된 후, @tt{(= sum (+ x y))}가 수행됨을
알 수 있다.

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
FAIL in (add) (core.clj:6)
expected: (= 9 (+ 4 4))
  actual: (not (= 9 8))
FAIL in (add) (core.clj:6)
expected: (= 7 (+ 2 4))
  actual: (not (= 7 6))
Ran 1 tests containing 3 assertions.
2 failures, 0 errors.
}|

@tt{are} 매크로는, 실제로는 여러 개의 @tt{is} 매크로로 확장된다. 확장된 모습을 살펴보자.

@coding|{
(macroexpand '(are [sum x y] (= sum (+ x y))
                   4 2 2
                   2 2 0
                   9 4 4
                   7 2 4))
; => (do 
;      (clojure.test/is (= 4 (+ 2 2)))
;      (clojure.test/is (= 2 (+ 2 0)))
;      (clojure.test/is (= 9 (+ 4 4)))
;      (clojure.test/is (= 7 (+ 2 4))))
}|

@tt{is} 매크로로 모두 확장된 것을 직접 확인할 수 있다.


@index['("testing" "macro" "clojure.test")]
@section{testing 매크로}

@descblock|{
(testing string & body)     <macro>   [clojure.test]
}|

@tt{testing} 매크로는, 테스트를 그룹화하기 위한 용도로 사용되고, 테스트가 실패할 경우
출력할 메시지를 지정할 수 있다.

@tt{deftest} 매크로 안에서 사용되어야 하며, 중첩될 수 있다.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(deftest arithmetic
  (testing "Addition"
    (testing "with positive integers"
      (is (= 4 (+ 2 2)))
      (is (= 7 (+ 3 4))))
    (testing "with negative integers"
      (is (= -5 (+ -2 -2)))             ; error here
      (is (= -1 (+ 3 -4))) )))
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
FAIL in (arithmetic) (core.clj:11)
Addition with negative integers
expected: (= -5 (+ -2 -2))
  actual: (not (= -5 -4))
Ran 1 tests containing 4 assertions.
1 failures, 0 errors.
}|

@index{thrown?}
@section{exception 테스트}

@descblock|{
(thrown? exception-class form)
(thrown? exception-class message form)

  exception-class -- form에서 발생이 예상되는 예외 클래스명.
  message -- 예외가 발생할 떄, 함께 전달되는 메시지. 정규식 문자열로 표시.
  form -- 예외를 발생하는 form

form에서 던진 예외가, exception-class와 일치하고, 함께 전달된 메시지가
message와 일치하면 테스트를 통과하고, 그렇지 않으면 테스트 실패. 
}|

@tt{is} 매크로 내에서, 예외가 실제로 발생하는 지를 테스트할 수 있다.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]) )

(deftest divide-by-zero
  ;; ArithmeticException 예외를 발생하므로, 테스트 통과
  (is (thrown? ArithmeticException (/ 1 0)))

  ;; ArithmeticException 예외를 발생하지 않으므로, 테스트 실패
  (is (thrown? ArithmeticException (/ 1 2)))

  ;; ArithmeticException 예외를 발생하고, 이때 전달되는 메시지가 일치하므로
  ;; 테스트 통과
  (is (thrown-with-msg? ArithmeticException #"Divide by zero"
                        (/ 2 0) ))

  ;; ArithmeticException 예외가 발생하지만, 이때 전달되는 메시지가 일치 안하므로
  ;; 테스트 실패
  (is (thrown-with-msg? ArithmeticException #"Incorrect message"
                        (/ 2 0) ))

  ;; ArithmeticException 예외를 발생하지 않으므로, 테스트 실패
  (is (thrown-with-msg? ArithmeticException #"Divide by zero"
                        (/ 1 3) )))
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
FAIL in (divide-by-zero) (core.clj:10)
expected: (thrown? ArithmeticException (/ 1 2))
  actual: nil
FAIL in (divide-by-zero) (core.clj:19)
expected: (thrown-with-msg? ArithmeticException #"Incorrect message" (/ 2 0))
  actual: #<ArithmeticException java.lang.ArithmeticException: Divide by zero>
FAIL in (divide-by-zero) (core.clj:23)
expected: (thrown-with-msg? ArithmeticException #"Divide by zero" (/ 1 3))
  actual: nil
Ran 1 tests containing 5 assertions.
3 failures, 0 errors.
}|


@index['("use-fixtures" "clojure.test")]
@section{fixture 사용하기}

테스트 코드를 작성하다 보면, 테스트 실행 직전 또는 직후에 실행되어야 하는 코드가
있을 수 있다. 이때 필요한 것이 바로 fixture이다.

@descblock|{
(use-fixtures :once fixture-1 fixture-2 ...)     [clojure.test]
(use-fixtures :each fixture-1 fixture-2 ...)

:once -- 테스트 파일 전체에 걸쳐, 'fixture-1 fixture-2 ...' 부분을 지정된
         순서대로 딱 한번만 수행한다.
:each -- deftest 문을 실행할 떄마다, 'fixture-1 fixture-2 ...' 부분을 지정된
         순서대로 메번 수행한다.
}|

@tt{:once} 옵션의 경우를 먼저 살펴보자.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(defn fixture-1 [f]
  (println ":once fixutre-1 started.")
  ; other codes here ...
  (f)
  (println ":once fixutre-1 ended.")
  ; another codes here ...
)

(defn fixture-2 [f]
  (println ":once fixture-2 started.")
  ; other codes here ...  
  (f)
  (println ":once fixture-2 ended.")
  ; another codes here ...
)

(use-fixtures :once fixture-1 fixture-2)

(deftest add
  (is (= 3 (+ 1 2)))
  (is (= 8 (+ 3 5))))

(deftest subtract
  (is (= 5 (- 10 5)))
  (is (= 2 (- 7  5))))
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
:once fixutre-1 started.
:once fixture-2 started.
:once fixture-2 ended.
:once fixutre-1 ended.
Ran 2 tests containing 4 assertions.
0 failures, 0 errors.
}|

테스트 종료시, 지정한 fixture 함수의 순서가 역순으로 실행되는 것에 주의하라.

이번에는 @tt{:each} 옵션의 경우를 살펴보자.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]))

(defn fixture-1 [f]
  (println ":each fixutre-1 started.")
  ; other codes here ...
  (f)
  (println ":each fixutre-1 ended.")
  ; another codes here ...
)

(defn fixture-2 [f]
  (println ":each fixture-2 started.")
  ; other codes here ...  
  (f)
  (println ":each fixture-2 ended.")
  ; another codes here ...
)

(use-fixtures :each fixture-1 fixture-2)

(deftest add
  (is (= 3 (+ 1 2)))
  (is (= 8 (+ 3 5))))

(deftest subtract
  (is (= 5 (- 10 5)))
  (is (= 2 (- 7  5))))
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
:each fixutre-1 started.
:each fixture-2 started.
:each fixture-2 ended.
:each fixutre-1 ended.
:each fixutre-1 started.
:each fixture-2 started.
:each fixture-2 ended.
:each fixutre-1 ended.
Ran 2 tests containing 4 assertions.
0 failures, 0 errors. 
}|

@tt{deftest} 문이 실행될 때마다, @tt{:each} 옵션 뒤에 지정한 fixture들이 지정된 순서대로
실행되는 것을 확인할 수 있다.


@section{deftest- 매크로}

@tt{lein test} 명령이 실행될 때, 각 테스트 코드 파일 내의 @tt{deftest} 문이 실행되는데,
@tt{deftest} 문이 코드 내에 나열된 순서 그대로 실행되지는 않는다. 그런데 그 순서를 지정할
필요가 있을 때는 어떻게 해야 할까?

일단, 다음과 같이 시도해 볼 수 있다.

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]) )

(deftest add
  (is (= 3 (+ 1 2)))
  (is (= 8 (+ 3 5))) )

(deftest subtract
  (is (= 5 (- 10 5)))
  (is (= 2 (- 7 5))) )

(deftest arithmetic
  (add)
  (subtract) )
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
Ran 5 tests containing 8 assertions.
0 failures, 0 errors.
}|

@tt{deftest} 문 내부에 나열된 테스트 코드는, 그 실행 순서가 보장된 것을 이용해서 작성한
코드이지만, 문제는 @tt{add} 테스트문과 @tt{subtract} 테스트문이 중복되어 실행된다는 데에
있다. 이 문제를 해결하기 위해서는 @tt{dettest-} 문을 이용해야 한다. @tt{deftest-} 문은
@tt{deftest} 문과 다른 면에서는 동일하지만, public 함수가 아닌, private 함수를 생성해
준다는 차이점이 있다(이것은 @tt{defn} 문과 @tt{defn-} 문 사이의 차이점과 동일하다.).

@coding|{
;; file: C:/work/myproject/test/myproject/test/core.clj
(ns myproject.test.core
  (:use [clojure.test]) )

(deftest- add
  (is (= 3 (+ 1 2)))
  (is (= 8 (+ 3 5))) )

(deftest- subtract
  (is (= 5 (- 10 5)))
  (is (= 2 (- 7 5))) )

(deftest arithmetic
  (add)
  (subtract) )
}|

@shellblock|{
c:\work\myproject> lein test
Testing myproject.test.core
Ran 5 tests containing 8 assertions.  <<-- ??
0 failures, 0 errors.
}|

@; TODO: private 함수 테스트


@section{cljs.test}

Most of the @tt{cljs.test} functionalities are provided as macros, which means that you
need the special CLJS @tt{:require-macros} option in the requirement declaration of a
testing namespace, while you do no need it in the corresponding CLJ namespace declaration.

