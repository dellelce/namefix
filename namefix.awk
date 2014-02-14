
 function try_rename(old,new)
 {
   if (old == new) return;

   cmd = "mv -- \""old"\" \""new"\""
   print cmd;
   print new;
   print ""
   system(cmd);
   totcnt=totcnt+1
 }

 BEGIN { totcnt = 0; unchanged = 0;  } 

 {
  onm=$0

  if (index(onm,"&") != 0)
  {
    print "removing ampersand: " onnm
    nnm = onm; # onm = old name, nnm = newname
    gsub(/\&/, "and", nnm);
    try_rename(onm, nnm);
    onm = nnm
  }

  if (index(onm,"$") != 0)
  {
    print "removing dollars: " onnm
    nnm = onm; # onm = old name, nnm = newname
    gsub(/\$/, "", nnm);
    try_rename(onm, nnm);
    onm = nnm
  }

  if (index(onm,")") != 0 || index(onm,"(") != 0)
  {
    print "removing brackets: " onnm
    nnm = onm; # onm = old name, nnm = newname
    gsub(/\)/, "", nnm);
    gsub(/\(/, "", nnm);
    try_rename(onm, nnm);
    onm = nnm
  }

  if (index(onm,"]") != 0 || index(onm,"[") != 0)
  {
    print "removing square brackets: " onm
    nnm = onm; # onm = old name, nnm = newname
    gsub(/\]/, "", nnm);
    gsub(/\[/, "", nnm);
    try_rename(onm, nnm);
    onm = nnm
  }
  
  fn_cnt = split(onm, fn_a, "/")
  nm=fn_a[fn_cnt]
 
  bnm = onm

  if (nm == "")
  {
    print "INVALID LINE: "$0
    next
  }

  #must escape plusses....
  gsub(/\+/,"\\+",nm);

  sub(nm,"",bnm);

  if (bnm == onm)
  {
    print "--- ERROR --"
    print "bnm = "bnm
    print "onm = "onm
    print "nm  = "nm
    next
  }

  # unescape plusses
  gsub(/\\\+/,"+",nm);

  sub(/--/,"-",nm);
  sub(/-\./,".",nm);
  gsub(/\'/,"", nm);
  gsub(/;/,"_", nm);
  gsub(/ /,"_", nm);
  gsub(/,/, "_",  nm);
  gsub(/^_/, "",  nm);
  gsub(/\.-\./,"_", nm);
  gsub(/_-_/,"_", nm);
  gsub(/_-/,"_", nm);
  gsub(/-_/,"_", nm);
  gsub(/\(/, "_", nm);
  gsub(/\)/, "_", nm);
  gsub(/____/, "_", nm);
  gsub(/___/, "_", nm);
  gsub(/__/, "_", nm);
  gsub(/,_/, "_", nm);
  gsub(/_\./, ".",  nm);
  gsub(/\._/, "_",  nm);
  gsub(/^-_/, "",  nm);
  gsub(/\.,/, "_",  nm);
  gsub(/\.\./, "_",  nm);
  gsub(/,_/, "_",  nm);

  fnm=bnm""nm

  if (onm != fnm)
  {
    if (length(fnm) > length(onm))
    {
      print "New name can't be longer than original"
      next
    }
    try_rename(onm, fnm);
  }
   else
  {
    unchanged = unchanged + 1
  }
} 

END {
      print ""
      print "Total changes: " totcnt" Unchanged: " unchanged
    }

