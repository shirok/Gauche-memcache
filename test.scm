;;;
;;; Test memcache
;;;

(use gauche.test)

(test-start "memcache")
(use memcache)
(test-module 'memcache)

(test-section "memcache")
(use gauche.version)
(define conn (memcache-connect "localhost" 11211))

(test* "set" #t (set conn 'abc "The Black\r\nMonday"))
(test* "get" '((abc . "The Black\r\nMonday")) (get conn 'abc))
(test* "delete" #t (delete conn 'abc))
(test* "get" '() (get conn 'abc))
(test* "replace" #f (replace conn 'coffee '("blue" "mountain")))
(test* "add" #t (add conn 'coffee 17))
(test* "incr" 30 (incr conn 'coffee 13))
(test* "decr" 26 (decr conn 'coffee 4))
(test* "replace" #t (replace conn 'coffee '("blue" "mountain")))
(test* "add" #f (add conn 'coffee #\B))
(test* "get" '((coffee . ("blue" "mountain"))) (get conn 'abc 'coffee))
(test* "flush-all" #t (flush-all conn))
(define v (version conn))
(test* "version" #t (version<=? "1.1.11" v))
(test* "flush_all (with a numeric argument)"
       (if (version<=? "1.1.13" v)
           #t
           *test-error*)
       (flush-all conn 30))
(write (stats conn))
(newline)
(quit conn)

(unless (library-exists? 'www.cgi.session)
  (test-end)
  (exit))

(use www.cgi.session.memcache)
(test-module 'www.cgi.session.memcache)
(test-section "www.cgi.session.memcache")
(define session (session-begin <cgi-session-memcache>))
(test* "is-a?" #t (is-a? session <cgi-session-memcache>))
(test* "id-of" #t (string? (id-of session)))
(test* "variables-of (init)" '() (variables-of session))
(test* "destroyed?" #f (destroyed? session))
(test* "timestamp-of" #f (timestamp-of session))
(session-set session 'foo "bar")
(test* "session-get" "bar" (session-get session 'foo))
(session-set session 'x '(a b d) 'y 345)
(test* "variables-of" '((y . 345) (x . (a b d)) (foo . "bar")) (variables-of session))
(test* "session-destroy" #t (session-destroy session))
(test* "destroyed?" #t (destroyed? session))

;; epilogue
(test-end)