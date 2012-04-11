#+TITLE: Notes: <ProGit>
#+LANGUAGE: en
#+AUTHOR: Haisheng Wu
#+EMAIL: freizl@gmail.com
#+DATE: 2011-01-06
#+OPTIONS: toc:1 num:nil
#+KEYWORDS:  Git
#+LINK_HOME: ../index.html

* Chapter 9.3
   - refs
   - refs/heads
   - refs/tags

#+begin_src sh
[remote "origin"]
    url = ...
    fetch = +refs/heads/* : refs/remotes/origin/*
      ===> fetch all the references under "refs/heads" on the server 
           and writes them to refs/remotes/origin locally
#+end_src

_Questions_
   1. What does 'git branch B_NAME' actually do?
   2. What happened to HEAD when switching branch?

* Chapter 6

#+begin_src sh
git add -i
#+end_src

#+begin_src sh
###
### revision selection
### ^ ::= parent of something, only two format ^ and ^2
git log HEAD^2 
git log d107aoeu^2
git log HEAD~3
#+end_src

#+begin_src sh
git log master..branchA
git log origin/master..HEAD
git log branchA branchB ^branchC
git log master...branchA
#+end_src

* Internal
  [[file:git_internal.png][Git internal in one image]]

* Reference
  + [[http://progit.org/book/][ProGit]]
