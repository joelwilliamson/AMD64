#!/bin/sh

# Call as `pas infile outfile`

gcc -E $1 -o /dev/stdout | as /dev/stdin -o $2
