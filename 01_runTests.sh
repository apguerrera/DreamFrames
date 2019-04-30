#!/bin/sh

# ----------------------------------------------------------------------------------------------
# Attaching to the test chain
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# Enjoy. (c) Adrian Guerrera / Deepyr Pty Ltd 2019. The MIT Licence.
# ----------------------------------------------------------------------------------------------


mkdir -p flattened
chmod 700 scripts/solidityFlattener.pl

cd test
python3 test.py
