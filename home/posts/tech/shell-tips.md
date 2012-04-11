#+TITLE: Shell Tips
#+LANGUAGE: en
#+AUTHOR: Haisheng Wu
#+EMAIL: freizl@gmail.com
#+DATE: 2010-02-01
#+OPTIONS: toc:nil
#+KEYWORDS:  Shell
#+LINK_HOME: ../index.html


* Quicklinks
  - [[http://bash.cyberciti.biz/guide/What_is_a_Subshell%3F][What is a Subshell]]
  - [[http://en.wikipedia.org/wiki/List_of_Unix_utilities][List of Unix utilities]]
  - [[http://www-128.ibm.com/developerworks/aix/library/au-badunixhabits.html?ca=lnxw01GoodUnixHabits][10 Good Unix habits]]

* Reference
  - () execute command in subshell
  - {} execute command in currecnt shell
       Usage is same with () expect the final command in the list ends with a semicolon.

* Sample Section A
** grep
#+begin_src sh
grep -Elr --include=*.xsd --exclude-dir={branches,tags} VendorDesc.xsd $DIRECTORY
### count process and exclude grep itself
ps aux | grep vpnc | grep -v grep -c
#+end_src
** find
#+begin_src sh
find ${1} \( -name Consume*wsdl -o -name Produce*wsdl \) -path *trunk*
find $update_dir \( -name '*.java' \) \( -path '**/source/**' -o -path '**/test/**' -o -path '**/resource/**' \)
#+end_src
** awk
#+begin_src sh
### list all time of each ping
awk -F"=" '/time=/ {print substr($4,0,length($4)-3) }' < ping.log
### passing shell parameter to awk scripts
svn st ${dirs} | awk -F" " -v ac="${*}" ' /'${predicate}'/ && (index($2,"\\")==0 || gsub(/\\/,"/",$2)) {print ac, $2}'
### change Output Row Separator
awk ' BEGIN { ORS = " " } { print }'
#+end_src
** sed
#+begin_src sh
ll | sed '/Stores\|Test\|^-\|^t/d' | wc
#+end_src
#+begin_src sh
smbclient -L \\\\hangzhou2\\twitters -U foobar | sed '/Hangzhou20/,$d'
#+end_src
#+begin_src sh
export BEA_IP=`/sbin/ifconfig eth0 | sed '/inet addr/!d;s/.*addr:\([^ ]\+\).*/\1/g'`
#+end_src

** cp
#+begin_src sh
cp filename{,.bak}
#+end_src

* Sample Section B
** while
#+begin_src sh
while getopts ":ab:c" opt; do
	case $opt in
	a ) echo "I am a" ;;
	b ) echo $OPTARG  ;;
	c ) echo "i am c" ;;
	? ) echo "usage : $0 [-a] [-b barg] [-c] args .."
	    exit 1 ;;
	esac
    shift $(($OPTIND - 1))
done
#+end_src
** for
#+begin_src sh
for s in $(echo $string | sed "s/;/ /g"); do
	echo $s
done
#+end_src
#+begin_src sh
for (( i=1; i<=$n; i++ )) do
   ls -1 "${file_pattern}" | sed 's#\(.*\)\(.xml\).bak#cp & \1'"_$i"'\2#g'
done
#+end_src
** case
#+begin_src sh
case $action in
    backup ) tar cfj "$backup_dir/$bakfile" * --exclude "jobs/*/workspace" ;;
    rest | restore ) tar xfj $backup_dir/$bakfile ;;
    * ) echo "all supported actions: backup | rest[ore]" ; exit 0 ;;
esac
#+end_src

