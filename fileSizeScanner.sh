#! /bin/sh

echo "MacOS Mojave or later has a more strict restriction on file access.
Check them and enable full disk access.
https://osxdaily.com/2018/10/09/fix-operation-not-permitted-terminal-error-macos/
https://qiita.com/KEINOS/items/0366f1c281b574a79cfb
"

echo "Disk summary: "
df -h

# # Root directory does not matter actually. 
# echo "Scan the root directory. Note that output does not show 'Operation not permitted' or 'Permission denied' error message and the protected filed are not included to the total size.
# sudo du -sm /* /.[^.]* 2>&1 | grep -v  '^du:' | sort -nr

echo "Scan the home directory. Note that output does not show 'Operation not permitted' or 'Permission denied' error message and the protected filed are not included to the total size.
Size unit is MiB."
out=$(sudo du -sm ~/* ~/.[^.]* 2>&1 | grep -v  '^du:' | sort -nr)

echo "Next, scan top 3 paths deeper with --max-depth=3"
cnt=0
for str in $out
do
if [[ $str == */* ]]; then
    echo $str
    filename="result/${str//\//-}.txt"
    sudo du -m -d 2 "$str"/* "$str"/.[^.]* 2>&1 | grep -v  '^du:' | sort -nr > $filename
    ((cnt++))
    if [[ $cnt -gt 3 ]]; then
        echo "break"
        break
    fi
fi
done

exit 0
