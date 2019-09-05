# convert wikipedia to lexicon program (c) Gregory Grefenstette
# This program is licensed under a Creative Commons Attribution 4.0 International License.
# You should have received a copy of the license along with this
# work.  If not, see <http://creativecommons.org/licenses/by/4.0/>.
# License Create Commons Attribution 
for i in aa ab ace af ak als am an ang ar arc arz as ast av ay az ba bar bcl be bg bh bi bjn bm bn bo bpy br bs bug bxr ca cdo ce ceb ch cho chr chy ckb co cr crh cs csb cu cv cy cz da de diq dsb dv dz ee el eml en eo es et eu ext fa ff fi fj fo fr frp frr fur fy ga gag gan gd gl glk gn got gu gv ha hak haw he hi hif ho hr hsb ht hu hy hz ia id ie ig ii ik ilo incubator io is it iu ja jbo jv ka kaa kab kbd kg ki kj kk kl km kn ko koi kr krc ks ksh ku kv kw ky la lad lb lbe lez lg li lij lmo ln lo lt ltg lv mdf mg mh mhr mi min mk ml mn mo mr mrj ms mt mus mwl my myv mzn na nah nan nap nds ne new ng nl nn no nov nrm nso nv ny oc om or os pa pag pam pap pcd pdc pfl pi pih pl pms pnb pnt ps pt qu rm rmy rn ro ru rue rw sa sah sc scn sco sd se sg sh si simple sk sl sm sn so sq sr srn ss st stats stq su sv sw szl ta te tet tg th ti tk tl tn to tpi tr ts tt tum tw ty tyv udm ug uk ur uz ve vec vep vi vls vo w wa war wikia wo wuu xal xh xmf yi yo za zea zh zu ; 
    do bzcat $i""wiki-latest-pages-articles.xml.bz2 |\
            gawk -f ./pack/dewiki.awk |  gawk  -f ./pack/UnSGML.awk |  gawk -f ./pack/sentencize.awk > $i.sentences ; 
     cat $i.sentences | egrep -vi '(TITLE|REDIRECT|CATEGORY)=' |\
            gawk --assign=LANG=$i -f ./pack/detectEnglish.awk |\
            tr "'*:=\[\]" " " | tr -s  ' "<>!?/{}^\\@_~%|' '\012' |  egrep -v '^[-0123456789,$.#+:;()%<>]+$' |\
            gawk '{ gsub("^[$+.-]*",""); print }' | sort -T . |\
            uniq -c | gawk '$2 ~ /[_0-9%<>@+&$,?!/\\{}]/ || /-.*-/ || /[.][.]+/ {next} {print}' > $i.lex ; 
     bzip2 -f $i.sentences ; echo $i ; 
    done
