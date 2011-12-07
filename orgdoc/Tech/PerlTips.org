#+TITLE: Perl Tips
#+LANGUAGE: en
#+AUTHOR: Haisheng Wu
#+EMAIL: freizl@gmail.com
#+DATE: 2011-05-01
#+OPTIONS: toc:nil
#+KEYWORDS: Perl
#+LINK_HOME: ../index.html

* Basic

#+begin_src perl
my @myarray = ();
push @myarray,"a";
#+end_src

#+begin_src perl
my @keys = qw(a b c);
my @vals = (1, 2, 3);
my %hash;
@hash{@keys} = @vals;
#+end_src

* Loop

#+begin_src perl
# loop elements in itemArray1 and itemArray2
foreach my $item (@itemArray1, @itemArray2) {
  ...
}

while ( my ($key, $value) = each(%hash) ) {
  print "$key => $value\n";
}
#+end_src

* Sub
#+begin_src perl
sub prepare_sth {
  my $param = shift;  # means shift @_, @_ is param array
  # my $param = $_;   # when could use $_ ??
}
#+end_src

#+begin_src perl
sub uniq {
  @list = shift;
  %seen = (); 
  @uniqu = grep { ! $seen{$_} ++ } @list;
}
#+end_src

* Data Structure

** AoA
from book <programming perl>
#+begin_src perl
### Assign a list of array references to an array.
@AoA = (
         [ "fred", "barney" ],
         [ "george", "jane", "elroy" ],
         [ "homer", "marge", "bart" ],
);
print $AoA[2][1];   # prints "marge"

### Create an reference to an array of array references.
$ref_to_AoA = [
    [ "fred", "barney", "pebbles", "bamm bamm", "dino", ],
    [ "homer", "bart", "marge", "maggie", ],
    [ "george", "jane", "elroy", "judy", ],
];

print $ref_to_AoA->[2][3];   # prints "judy"
#+end_src
Remember that there is an implied -> between every pair of adjacent
braces or brackets. *(Simply saying, -> indicates a reference which
created via [])*.

Therefore these two lines: 
#+begin_src perl
$AoA[2][3]
$ref_to_AoA->[2][3]
#+end_src
are equivalent to these two lines: 
#+begin_src perl
$AoA[2]->[3]
$ref_to_AoA->[2]->[3]
#+end_src

* References
  + [[http://www.cs.mcgill.ca/~abatko/computers/programming/perl/howto/hash/][Perl Hash Howto]]
