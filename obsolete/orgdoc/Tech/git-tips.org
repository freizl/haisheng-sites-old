#+TITLE: Git Tips
#+LANGUAGE: en
#+AUTHOR: Haisheng Wu
#+EMAIL: freizl@gmail.com
#+DATE: 2011-02-06
#+OPTIONS: toc:1 num:nil
#+KEYWORDS:  Git
#+LINK_HOME: ../index.html

* fetch
#+begin_src sh
### fetch origin "FROM" : "TO"
fetch = +refs/heads/master:refs/remotes/origin/master

git fetch origin master:refs/remotes/origin/mymaster
git fetch origin master:refs/remotes/origin/mymaster
          topic:refs/remotes/origin/topic
#+end_src

* one commit
  [[file:git_one_commit.pdf][What happened after one commit]]

* log
* miscs
#+begin_src sh
git instaweb --httpd=lighttpd

### anything need push
git remote show origin

### init new repos
git clone --bare my_project my_project.git

git reset --hard 7e83	

git checkout 82f5 [-b branch_name]	This takes you back in time, while preserving newer commits.
git checkout :/"my first brach"	        Jump to the commit that starts with a given message.
git checkout master~5	                5th last saved state.(BRANCH_NAME~number)
	
git whatchanged 	
git cherry-pick	
	
git rebase	
git rebase -I HEAD~10	modify last 10 commits
git commit --amend	
	
git filter-branch --tree-filter 'rm top/sececre/file' HEAD	remove file from all commit
	
git bundle	
	
git branch -r	

###diff with remote branch,a.k. what are local change
git diff remotes/HEAD	
	
git reflog	

#+end_src
