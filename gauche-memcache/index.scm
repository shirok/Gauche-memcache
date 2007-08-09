#!/usr/bin/env gosh

(use file.util)
(use fixedpoint.site)
(use text.html-lite)
(use text.tree)

(//
 (PHP "http://www.php.net/")
 (memcached "http://www.danga.com/memcached/")
 )

(define *last-update* "Fri Aug 10 2007")
(define *gauche-memcache-version* (file->string "../VERSION"))
(define *gauche-memcache-tarball-basename* (string-append "Gauche-memcache-" *gauche-memcache-version* ".tgz"))
(define *gauche-memcache-tarball-size* (file-size (string-append "../../" *gauche-memcache-tarball-basename*)))
(define *gauche-memcache-tarball-url* *gauche-memcache-tarball-basename*)

(define (index lang)
  (let-syntax ((en/ja (syntax-rules ()
						((_ en ja)
						 (if (string=? "en" lang) en ja)))))
	((fixedpoint:frame "Gauche-memcache")
	 (html:p :id "lang_navi" (html:a :href (en/ja "index.html" "index.en.html")
										"[" (en/ja "Japanese" "English") "]"))
	 (html:p :id "last_update" "Last update: " *last-update*)
	 (fixedpoint:separator)
	 (fixedpoint:adsense)
	 (fixedpoint:separator)
	 (html:p (html:dfn /Gauche-memcache/)
			 (en/ja
              (list " is an extension package of " /Gauche/ " providing " /memcached/ " client utility.")
              (list " �� " /Scheme/ " ������ " /Gauche/ " �� " /memcached/ " �Υ��饤����ȵ�ǽ�����Ѥ��뤿��γ�ĥ�ѥå������Ǥ���")))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "News" "�ǿ�����"))
	 (html:ul
	  (html:li "[2007-08-10] " (en/ja "Release 0.1.0." "�С������ 0.1.0 ��������ޤ�����")))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Features" "��ħ"))
	 (html:ul
	  (html:li (en/ja "memcached client API"
					  "memcached ���饤����� API"))
	  (html:li (en/ja (list "memcache based CGI session with " /Gauche-cgi-ext/)
					  (list /Gauche-cgi-ext/ " �ˤ�� memcached �١����� CGI ���å����")))
	  )

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Requirements" "Ƴ��"))
	 (html:p (en/ja "This package is for Gauche 0.8.10 or later."
					"���Υѥå������� Gauche 0.8.10 �ޤ��Ϥ���ʾ��ư��ޤ���"))
	 (html:ul
	  (html:li (en/ja (list "If you would like memcache based CGI session, "
                            /memcached/ " and also " /Gauche-memcache/ " are necessary.")
					  (list "�ޤ� memcache �ˤ�� CGI ���å��������Ѥ�����ˤ�"
                            /memcached/ " ����� "/Gauche-memcache/ " ��ɬ�פǤ���"))))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Download" "���������"))
	 (html:p (html:a :href *gauche-memcache-tarball-url*
					 *gauche-memcache-tarball-basename* " (" *gauche-memcache-tarball-size*  " bytes)"))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Documentation" "ʸ��"))
	 (html:ul
	  (html:li (html:a :href (en/ja "reference.en.html" "reference.ja.html")
					   "Gauche-memcache " (en/ja "Reference Manual" "��ե���󥹥ޥ˥奢��"))))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" "FYI")
	 (html:ul
	  (html:li /memcached/)
	  (html:li /PHP/)
	  )
	 )))

(define (main args)
  (define (usage)
	(format (current-error-port) "usage: gosh ~a (en|ja)\n" *program-name*)
	(exit 1))
  (when (< (length args) 2)
	(usage))
  (write-tree (index (cadr args)))
  0)
