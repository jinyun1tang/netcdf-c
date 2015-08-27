#!/bin/sh
# This shell script runs ncdump tests relating to the new UTF8 name stuff.
# $Id:$

set -e
echo ""
echo "*** Testing ncgen and ncdump for UTF8 support..."

if test "x$builddir" = x ; then
builddir="."
fi
if test "x$srcdir" = x ; then
srcdir="."
fi
if test "x$top_srcdir" = x ; then
top_srcdir=".."
fi

HASNC4=`$top_srcdir/nc-config --has-nc4`

rm -f utf8.nc utf8.cdl
echo "*** creating classic offset file with utf8 characters..."
../ncgen/ncgen -b -o utf8.nc ${srcdir}/ref_tst_utf8.cdl
echo "*** dump and compare utf8 output..."
./ncdump utf8.nc > utf8.cdl
diff -b -w utf8.cdl ${srcdir}/ref_tst_utf8.cdl

if test "x$HASNC4" = xyes ; then
rm -f utf8.nc utf8.cdl
echo "*** creating enhanced file with utf8 characters..."
../ncgen/ncgen -4 -b -o utf8.nc ${srcdir}/ref_tst_utf8_4.cdl
echo "*** dump and compare utf8 output..."
./ncdump utf8.nc > utf8.cdl
diff -b -w utf8.cdl ${srcdir}/ref_tst_utf8_4.cdl
fi

rm -f utf8.nc utf8.cdl
echo "*** creating 64-bit offset file with utf8 characters..."
../ncgen/ncgen -k 64-bit-offset -b -o utf8.nc ${srcdir}/ref_tst_utf8.cdl
echo "*** (64 bit) dump and compare utf8 output..."
./ncdump utf8.nc > utf8.cdl
diff -b -w utf8.cdl ${srcdir}/ref_tst_utf8.cdl

echo "*** dumping tst_utf8.nc to tst_utf8.cdl..."
rm -f tst8.cdl
sed -e 's/^netcdf tst_unicode/netcdf tst_utf8/' <${srcdir}/ref_tst_unicode.cdl >tst8.cdl
./ncdump tst_utf8.nc > tst_utf8.cdl
echo "*** comparing tst_utf8.cdl with tst8.cdl..."
diff -b -w tst_utf8.cdl tst8.cdl
rm -f tst8.cdl result
echo "*** All utf8 tests of ncgen and ncdump passed!"
exit 0
