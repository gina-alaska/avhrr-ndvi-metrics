;=== MAKELIST ===
;  This procedure generates a list of all .img files in            
;  the current directory.
;  Output file looks like:
;     nim
;     path (with trailing slash)
;     img files...


PRO makelist, outfile, suffix

command = "ls -1 *"+suffix+" |wc -l >"+outfile
spawn, command

command = "echo `pwd`/ >>"+outfile
spawn, command

command = "ls -1 *"+suffix+" >>"+outfile
spawn, command

end
