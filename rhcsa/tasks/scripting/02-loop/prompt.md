Write an executable shell script:

  /usr/local/bin/sumargs.sh

It must loop over all of its command-line arguments ("$@") with a
for loop, add them up as integers, and print the total sum.

The script must be executable.

Examples:
  sumargs.sh 2 3 5   ->  10
  sumargs.sh 4       ->  4
