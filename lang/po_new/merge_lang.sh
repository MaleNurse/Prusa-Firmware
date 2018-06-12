#!/bin/sh
#
#

LANG=$1
if [ -z "$LANG" ]; then exit -1; fi

#convert '\\e' sequencies to 'x1b' and '\\' to '\'
cat $LANG.po | sed 's/\\\\e/\\x1b/g;s/\\\\/\\/g' > $LANG'_filtered.po'

#join lines with multi-line string constants
cat $LANG'_filtered.po' | sed ':a;N;$!ba;s/\x22\n\x22//g' > $LANG'_new.po'

#generate dictionary
cat ../lang_en.txt | sed 's/\\/\\\\/g' | while read -r s; do
 /bin/echo -e "$s"
 if [ "${s:0:1}" = "\"" ]; then
#  /bin/echo -e "$s"
  s=$(/bin/echo -e "$s")
  s2=$(grep -F -A1 -B0  "$s" "$LANG"_new.po | tail -n1 | sed 's/^msgstr //')
  if [ -z "$s2" ]; then
   echo '"\x00"'
  else
   echo "$s2"
  fi
#  echo
 fi
done > lang_en_$LANG.txt
