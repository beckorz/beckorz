#!/bin/sh
#
# .default & original file copy/output diff

# Create save dir
#
SAVEDIR=$HOME'/tmp'
if [ -d $SAVEDIR ]; then
	rm -fr $SAVEDIR
fi
mkdir $SAVEDIR

# Find .default & copy
#
TMPFILE=$SAVEDIR/difflist.txt
find / -name "*.default" -or -name ".*.default" > $TMPFILE 2>/dev/null
while read BAKFILE; do
	BAKDIR=`dirname $BAKFILE`
	BAKFILE=`basename $BAKFILE`
	ORGFILE=`basename $BAKFILE .default`
	DIFFILE=$ORGFILE.diff
	if [ -f "$BAKDIR/$ORGFILE" ]; then
		cp -fp $BAKDIR/$BAKFILE $SAVEDIR
		cp -fp $BAKDIR/$ORGFILE $SAVEDIR
		diff -u $BAKDIR/$BAKFILE $BAKDIR/$ORGFILE > $SAVEDIR/$DIFFILE
		if [ ! -s $SAVEDIR/$DIFFILE ]; then
			rm -f $SAVEDIR/$DIFFILE
			rm -f $SAVEDIR/$ORGFILE
			rm -f $SAVEDIR/$DIFFILE
		fi
	fi
done < $TMPFILE

exit
