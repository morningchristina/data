#!/bin/bash
dd=$1
echo -n "$dd	"
echo "select user_id,account,addtime from dw_borrow_tender where user_id in (select * from (select user_id from dw_borrow_tender where debt_type!=2 and from_unixtime(addtime, '%Y%m%d')<='${dd}' group by user_id having count(1)=2 and from_unixtime(max(addtime),'%Y%m%d')='${dd}') t ) and debt_type!=2 order by id desc;"|$MYSQL|awk '{if(NR>1)print}'|sort -k 1 -k 3 -n > 123.txt
#echo "select user_id,account,addtime from dw_borrow_tender where user_id in (select * from (select user_id from dw_borrow_tender where debt_type!=2 group by user_id having count(1)=2 and from_unixtime(max(addtime),'%Y%m%d')='${dd}') t ) and debt_type!=2 order by id desc;"|./mysql|awk '{if(NR>1)print}'|sort -k1,3 -n > 123.txt
#echo "select user_id,account,addtime "
awk 'BEGIN{
	smallcnt=0;
	smallsum=0;
	bigcnt=0;
	bigsum=0;
	tt1=0;
	tt2=0;
	lastact=0;
	lasttime=0;
	firstbigsecondsmall=0;
}{
	if($1 in user1){
		if(lastact<10000){
			smallcnt++;
			smallsum+=($3-lasttime);
			if($2>=10000){
				firstbigsecondsmall++;
			}
		}else{
			bigcnt++;
			bigsum += ($3-lasttime);
		}
	}else{
		user1[$1]=1;
		lastact=$2;
		lasttime=$3;
	}
}END{
	if(smallcnt>0){
		avgsmall = smallsum/smallcnt/86400;
	}else{
		avgsmall=0;
	}
	if(bigcnt>0){
		avgbig = bigsum/bigcnt/86400;
	}else{
		avgbig=0;
	}
	print avgsmall, avgbig, firstbigsecondsmall;
}' 123.txt
