#!bin/bash
source ../conf/config.sh
dd=$1
#echo -n "本次活动一共被邀请投资的人数和投资总额: "

#echo "select count(user_id),sum(account) from dw_borrow_tender where user_id in (select invite_userid from dw_user where addtime<=1405267199 and addtime>=1402588800 and invite_userid>0 and invite_userid not in ('27225','3582','27222','6729','380','27221','507','562','6570','7440','5437','30998','32123','41408','81589','83032','85113')) and addtime<=1405267199 and addtime>=1402588800"|$MYSQL|awk '{if(NR>1)print}' 

echo "select distinct invite_userid from dw_user where addtime<=1405267199 and addtime>=1402588800 and invite_userid>0 and invite_userid not in ('27225','3582','27222','6729','380','27221','507','562','6570','7440','5437','30998','32123','41408','81589','83032','85113')"|$MYSQL|awk '{if(NR>1)print}'>invite_userid.txt 
echo "select user_id,account  from dw_borrow_tender where addtime<=1405267199 and addtime>=1402588800"|$MYSQL|awk '{if(NR>1)print}' >tender_userid.txt

#echo "select user_id,account,addtime from dw_borrow_tender where user_id in (select * from (select user_id from dw_borrow_tender where user_id in (select user_id from dw_user where addtime<=1405267199 and addtime>=1402588800 and invite_userid>0 and invite_userid not in ('27225','3582','27222','6729','380','27221','507','562','6570','7440','5437','30998','32123','41408','81589','83032','85113'))group by user_id having count(1)>=2) t )" |$MYSQL|awk '{if(NR>1)print}'|sort -k 1 -k 3 -n >first_invest.txt

#echo -n "本次活动有被邀请投资人中复投的人数:"
#echo "select count(distinct user_id) from dw_borrow_tender where user_id in (select * from (select user_id from dw_borrow_tender where user_id in (select user_id from dw_user where addtime<=1405267199 and addtime>=1402588800 and invite_userid>0 and invite_userid not in ('27225','3582','27222','6729','380','27221','507','562','6570','7440','5437','30998','32123','41408','81589','83032','85113'))group by user_id having count(1)>=2) t )" |$MYSQL|awk '{if(NR>1)print}'
#echo -n "复投周期,100-500,500-1K,1K-5K,5K-1W,1W以上):"

awk 'BEGIN{
    sum=0;
    count=0;
    lasttime=0;
    count1=0;
    count2=0;
    count3=0;
    count4=0;
    count5=0;
}{
    if($1 in user){
        if($1 not in flag){
        }
        else{
            sum+=($3-lasttime);
            flag[$1]=1;
        }
    }
    else{
        user[$1]=1;
        lasttime=$3;
        count++;
        if($2>=100 && $2<500){
            count1+=1;
        }
        if($2>=500 && $2<1000){
            count2+=1;
        }
        if($2>=1000 && $2<5000){
            count3+=1;
        }
        if($2>=5000 && $2<10000){
            count4+=1;
        }
        if($2>=10000){
            count5+=1;
        }
        }
}
    END{
        if(count>0){
            average=sum/count/86400;
        }
        else{
            average=0;
        }
        print average,count1,count2,count3,count4,count5;
}' first_invest.txt
        


