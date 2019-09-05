# Sentencizer program (c) Gregory Grefenstette
# This program is licensed under a Creative Commons Attribution 4.0 International License.
# You should have received a copy of the license along with this
# work.  If not, see <http://creativecommons.org/licenses/by/4.0/>.
# The following is an gawk program for tokenising English
# Comments,  like this line begin with a sharp sign (#)
# 'gawk' is a GNU version of Unix's awk, freely obtainable
# on the Internet, for example at ftp://prep.ai.mit.edu/pub/gnu
#
# What follows BEGIN is executed before any lines are read
BEGIN {      
# Here we initialise some regular expression expressed as strings
  Letter = "[A-ZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝa-zàáâãäåæèéêëìíîïòóôõöøùúûüç']";
  NotLet = "[^A-ZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝa-zàáâãäåæèéêëìíîïòóôõöøùúûüç'0-9]";
  AlwaysSep = "„#\"«»‘“”•?!()\";/\\|,`" ;
  BeginSep = "„('|&)";
  EndSep = "('|:|-|'S|'D|'M|'LL|'RE|'VE|N'T|'s|'d|'m|'ll|'re|'ve|n't)";

# gawk supports associative arrays (hash tables) 
# Here we give a non-zero value to all strings that we 
# explicitly consider as abbreviations
      Abbr["Co."]=1;
      Abbr["Corp."]=1;
      Abbr["vs."]=1;
      Abbr["e.g."]=1;
      Abbr["etc."]=1;
      Abbr["ex."]=1;
      Abbr["cf."]=1;
      Abbr["eg."]=1;

      Abbr["Rep."]=1;
      Abbr["Sen."]=1;
      Abbr["Gen."]=1;
      Abbr["Gov."]=1;
      Abbr["Col."]=1;
      Abbr["Capt."]=1;
      Abbr["Lt."]=1;

      Abbr["Calif."]=1;
      Abbr["Tenn."]=1;
      Abbr["Pa."]=1;
      Abbr["Va."]=1;

      Abbr["Jan."]=1;
      Abbr["Feb."]=1;
      Abbr["Mar."]=1;
      Abbr["Apr."]=1;
      Abbr["Jun."]=1;
      Abbr["Jul."]=1;
      Abbr["Aug."]=1;
      Abbr["Sep."]=1;
      Abbr["Sept."]=1;
      Abbr["Oct."]=1;
      Abbr["Nov."]=1;
      Abbr["Dec."]=1;
      Abbr["jan."]=1;
      Abbr["feb."]=1;
      Abbr["mar."]=1;
      Abbr["apr."]=1;
      Abbr["jun."]=1;
      Abbr["jul."]=1;
      Abbr["aug."]=1;
      Abbr["sep."]=1;
      Abbr["sept."]=1;
      Abbr["oct."]=1;
      Abbr["nov."]=1;
      Abbr["dec."]=1;

      Abbr["ed."]=1;
      Abbr["eds."]=1;
      Abbr["repr."]=1;
      Abbr["trans."]=1;
      Abbr["vol."]=1;
      Abbr["vols."]=1;
      Abbr["rev."]=1;
      Abbr["est."]=1;
      Abbr["b."]=1;
      Abbr["m."]=1;
      Abbr["bur."]=1;
      Abbr["d."]=1;
      Abbr["r."]=1;
      Abbr["M."]=1;
      Abbr["Dept."]=1;
      Abbr["MM."]=1;
      Abbr["U."]=1;
      Abbr["Mr."]=1;
      Abbr["Jr."]=1;
      Abbr["Ms."]=1;
      Abbr["Mme."]=1;
      Abbr["Mrs."]=1;
      Abbr["Dr."]=1;
       }
NF==0 { $0 = " . " }
# The following commands are applied to all input lines.
# The gawk-default field separators are the space and the tab.
#
# This line changes tabs into spaces
{ gsub("\t"," "); }
#
# put blanks around characters that are unambiguous separators
{ gsub("["AlwaysSep"]"," & "); }
#
# If a word is a separator in the beginning of a token
# separate it here
{ gsub("^"BeginSep,"& "); }
{ gsub(NotLet""BeginSep,substr("&",1,1)" "substr("&",2)) };
#
# Idem for final separators
#
#
{ gsub(EndSep"$"," &"); }
{ gsub(EndSep""NotLet,substr("&",1,length("&")-1)" "substr("&",length("&"),1)) };
#
#
# gawk divided the input line into fields using
# the tab and the space character as separators.
# NF is a  gawk variable automatically set to the number of fields
# gawk also creates variable $1, $2, $3, ... $NF containing
# the field strings
#
{ for(i=1;i<=NF;i++) if ($i ~/[A-ZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝa-zàáâãäåæèéêëìíîïòóôõöøùúûüç'][.]$/) 
# We loop over the number of fields
# And if the field contains a letter followed by a period
# we see if it is an abbreviation
    { 
# If the field is explicitly found in the Abbreviation list (Abbr)
# Or matches the regular expression below, we keep the period attached
    if ($i in Abbr) continue ;
    if ($i ~  /^([A-Za-z]\.([A-Za-z]\.)+|[A-Z]\.|[A-Z][bcdfghj-np-tvxz]+\.)$/ ) continue;
# If not, a space is inserted before the period
    sub("[.]$"," .",$i);
   }} 
#
# Change all spaces to new-lines, print tokenised line
#
{   gsub("[ \t]+"," "); gsub(" [.!?¿]","&\n"); gsub("' '","\""); gsub("\140 \140 ","\""); 
# rejoin together 12 , 450 , 999
   gsub("[0-9] ,","&COMMACOMMAXYZ"); 
   gsub(",COMMACOMMAXYZ [0-9]","COMMACOMMAXYZ&");
   gsub(" COMMACOMMAXYZ,COMMACOMMAXYZ ",",");
   gsub("COMMACOMMAXYZ","");
   gsub("[ ]('S|'D|'M|'LL|'RE|'VE|N'T|'s|'d|'m|'ll|'re|'ve|n't)","ERACEXYXME&");
   gsub("ERACEXYXME ","");
 if ($0 ~ / [.!?¿][ "]*$/) print; else printf("%s ",$0);  }
#
