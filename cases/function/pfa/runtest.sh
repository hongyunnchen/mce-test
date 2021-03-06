#!/bin/bash

cat <<-EOF

***************************************************************************
Pay attention:

This test is for memory PFA support test. PFA test will conflict with EDAC.
Before the test EDAC related drivers must be removed from the kernel (Not
built-in or rmmod). Moreover, PFA support need correct BIOS setting and
mcelog setting. If you are not familiar with it, please skip this test.

NOTE: CPU sleep may decrease the test efficiency. To avoid this situation,
one can run *load.sh" by hand before the formal test!
***************************************************************************


EOF

TMP="../../../work"
TMP_DIR=${TMP_DIR:-$TMP}
if [ ! -d $TMP_DIR ]; then
	TMP_DIR=$TMP
fi
export TMP_DIR

echo 0 > $TMP_DIR/error.$$

pushd `dirname $0` > /dev/null
./run_pfa.sh
[ $? -eq 0 ] || echo 1 > $TMP_DIR/error.$$
popd > /dev/null

grep -q "1" $TMP_DIR/error.$$
if [ $? -eq 0 ]
then
	echo "PFA test FAILS"
	exit 1
else
	echo "PFA test PASSES"
	exit 0
fi

