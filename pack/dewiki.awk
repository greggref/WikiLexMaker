# Dewiki program (c) Gregory Grefenstette
# This program is licensed under a Creative Commons Attribution 4.0 International License.
# You should have received a copy of the license along with this
# work.  If not, see <http://creativecommons.org/licenses/by/4.0/>.
function cleanline() {
#    print "FFF",$0;
    gsub("&quot;"," "); 
    gsub("&lt;br&gt;"," . "); 
    gsub("&lt;br/&gt;"," . "); 
    gsub("&lt;br /&gt;"," . "); 
    gsub("{{[^}]+}}","") ;
    gsub("&lt;[!]--","<!--"); gsub("--&gt;","-->"); 
    gsub("<[!]--[^>]*-->"," ");
    gsub("&lt;ref[^&]*/&gt;"," "); 
    gsub("&lt;div[^&]*/&gt;"," "); 
     gsub("&lt;ref[^&]*&gt;[^&]*&lt;/ref&gt;"," ");
     gsub("&lt;(div[^&]*|.?inputbox)&gt;"," ");
     gsub("&lt;/ref&gt;","</ref>"); 
     gsub("&lt;/div&gt;","</div>"); 
     gsub("&lt;ref[^&]*&gt;","<ref>");  
     gsub("<ref[^>]*/>"," ");
     gsub("<ref[^>]*>[^<]*</ref>"," ");
     gsub("&lt;[^&]*&gt;","");
     gsub("''","");
#     print "GGG",$0;
}
BEGIN {IGNORECASE=1 ; intext=0}
{ cleanline(); }
/<title/ { gsub(" *<[^>]*> *",""); title=$0; if (!(title ~ /:/)) print "TITLE="title" . " ; intext=0;  next }
/<redirect title/ { sub("[^\"]*\"",""); sub("\".*",""); print "REDIRECT="$0" ." }
/\[\[categor/ {  gsub("\\\[\\\[[^:]*:","") gsub("([|].*)?\\\]\\\]","");
      if(!(title ~ /:/)) print "CATEGORY="$0" . " ; intext=0 ; next }
# { print intext,$0}
  /<text/ { if(title ~/[:]/) next ; if(!($0 ~ /#REDIRECT/)) intext=1  ;  gsub(" *<[^>]*> *","") }

  intext == 1 && /<[!]--/ {  sub("<[!]--.*","") ; new0=$0; 
      while(!($0 ~ /-->/)){ eof=getline; if(eof==0) { print "EOF 1** " ; exit} ; cleanline() ; if ($0 ~ /<.text/) { print "*****ERR1"; intext=0; print new0; break ; print "*1"}  }
  sub("^[^>]*-->"," ");
  $0=new0" "$0;
		  }

intext == 1 && /<ref[^>]*/ {  sub("<ref[^>]*.*","") ; new0=$0;
    while(!($0 ~ /<\/ref>/)){  eof=getline; if(eof==0) { print "EOF 2***" ; exit} ; cleanline() ;  if ($0 ~ /<.text/) { print "*****ERR2"; intext=0; print new0;  break ; print "*2"}  } 
  sub("^[^<]*<.ref>"," ");
  $0=new0" "$0
}

intext == 1 && /<ref[^>]*/ {  sub("<ref[^>]*.*","") ; new0=$0;
    while(!($0 ~ /<\/ref>/)){  eof=getline; if(eof==0) { print "EOF 3***" ; exit} ; cleanline() ;  if ($0 ~ /<.text/) { print "*****ERR3"; intext=0; print new0;  break ; print "*3"}  }
    sub("^[^<]*<.ref>"," ");
  $0=new0" "$0
}

intext == 1 && /<ref[^>]*/ {  sub("<ref[^>]*.*","") ; new0=$0;
    while(!($0 ~ /<\/ref>/)){  eof=getline; if(eof==0) { print "EOF 4***" ; exit} ; cleanline() ;  if ($0 ~ /<.text/) { print "*****ERR3"; intext=0; print new0;  break ; print "*3"}  }
    sub("^[^<]*<.ref>"," ");
  $0=new0" "$0
}

intext == 1 && /{{/ { sub("{{[^}]*","") ; new0=$0;
    while(!($0 ~ /}}/)) { eof=getline; if(eof==0) { print "EOF 5***" ; exit} ; cleanline() ;   if ($0 ~ /<.text/) { print "*****ERR4"; intext=0; print new0;   break ; } }
  sub("[^}]*}}","");  
  $0=new0" "$0;
 }

intext==1   {
#  if($0 ~ /^([|!]|{[|])/) next ;
  if($0 ~ /^([!]|{[|])|[|][-}0-9]+/) next ;
  gsub("[|][^|]*=[^|]*[|]+"," . "); # remove formatting from tables
  gsub("^[|]",". ");
 gsub("{{[^}]+}}"," ");
 gsub("\\\[http[^\\\]\\\[]*\\\]",""); 
 gsub("\\\[\\\[[^\\\]\\\[]*\\\|","");
 gsub("\\\[\\\[","");
 gsub("\\\]\\\]","");
 gsub("<ref[^>]*>[^<]*</ref>"," ");
     gsub("<ref[^>]*\\\/>"," ");

# gsub("<.?ref[^<>]*>"," ");
 if($0 ~ /^ *==+(See Also|Further Reading|External links)/ ) intext=0 ;
 if($0 ~ /^ *==+/ ) next ;
 gsub("<[!]--[^>]*-->"," ");
 gsub("^ *[*].*","& . ");  # break up lists
 gsub("[*]+","& "); 
 gsub("&amp;nbsp;"," ") # space that got away
 gsub("<[^>]*>"," "); # all other markup removed
 gsub("^[a-z]+=[^ ]*",""); # stray markup
 print 
}
/<\/text/ {intext=0}
