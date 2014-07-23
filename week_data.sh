#!/bin/bash
source ../conf/config.sh

dd=`date -d"-1 day" +%Y%m%d` 

#每月合作金融机构的数量
echo "insert into itz_stat_week_guarantor select from_unixtime(addtime,'%Y/%m') as time,count(gid) from dw_guarantor_new where status=2 group by time"|$MYSQL|awk '{if(NR>1)print}'
#每个省的金融机构数量
echo "insert into itz_stat_guarantor(province_id,guarantor_num) select distinct province,count(province) from dw_guarantor_new group by province"|$MYSQL|awk '{if(NR>1)print}'
#每月用户投资总额
echo "insert into itz_stat_week_invest select from_unixtime(addtime,'%Y/%m') as time,sum(account_yes) from dw_borrow where 1 group by time"|$MYSQL|awk '{if(NR>1)print}'

#债权转让成功数量
echo -n "transfer_numbers  ">>$DATA_PATH/week_${dd}.txt
echo "select count(distinct user_id) from dw_debt where status=2"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#债权转让成功金额
echo -n "transfer_money ">>$DATA_PATH/week_${dd}.txt
echo "select sum(money) from dw_debt where status=2"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#用户中最多的续投次数
echo -n "most_renewal   ”“">>$DATA_PATH/week_${dd}.txt
echo "select count from (select user_id,count(user_id) as count from dw_credit_log where type_id=17 group by user_id order by count desc limit 1) t"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#用户中最高的投资总金额
echo -n "most_investment    ">>$DATA_PATH/week_${dd}.txt
echo "select sum from (select user_id,sum(account) as sum from dw_borrow_tender group by user_id order by sum desc limit 1) t"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#用户中最多的投资笔数
echo -n "most_frequency ">>$DATA_PATH/week_${dd}.txt
echo "select count from (select user_id,count(user_id) as count from dw_borrow_tender group by user_id order by count desc limit 1) t"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#债权转让后平均收益
echo -n "aftertransfer  ">>$DATA_PATH/week_${dd}.txt
echo "select sum(money*real_apr_b*(repayment_time-endtime)/86400/30)/sum(money*(repayment_time-endtime)/86400/30) from dw_debt where status=2"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#债权转让前平均收益
echo -n "beforetransfer ">>$DATA_PATH/week_${dd}.txt
echo "select sum(money*apr*(dw_borrow.repayment_time-endtime)/86400/30)/sum(money*(dw_borrow.repayment_time-endtime)/86400/30) from dw_debt left join dw_borrow on dw_debt.borrow_id=dw_borrow.id where dw_debt.status=2"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#奖励总金额
echo -n "coupon_money   ">>$DATA_PATH/week_${dd}.txt
echo "select sum(virtual_money)+sum(amount) from dw_account_virtual_log,dw_coupon"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#获得奖励的用户数
echo -n "coupon_user    ">>$DATA_PATH/week_${dd}.txt
echo "select count(distinct dw_account_virtual_log.user_id)+count(distinct dw_coupon.user_id) from dw_account_virtual_log,dw_coupon"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#项目平均收益率
echo -n "apr    ">>$DATA_PATH/week_${dd}.txt
echo "select sum(account*apr*(repayment_time-verify_time)/86400/30)/sum(account*(repayment_time-verify_time)/86400/30) from dw_borrow where status=2"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
#续投率
echo -n "renewal_rate   ">>$DATA_PATH/week_${dd}.txt
echo "select a.count1/b.count2 from (select count(user_id) as count1 from dw_credit_log where type_id=17) a ,(select count(distinct user_id) as count2 from dw_borrow_tender where status=2)b"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/week_${dd}.txt
 
echo "select user_id,sum(account),count(1) from dw_borrow_tender group by user_id"|$MYSQL|awk '{if(NR>1)print}' >$DATA_PATH/user.txt
echo "select distinct card_id from dw_borrow_tender left join dw_user on dw_borrow_tender.user_id=dw_user.user_id where real_status=1"|$MYSQL|awk '{if(NR>1)print}' >$DATA_PATH/id.txt

awk 'BEGIN{!a[$2]++}{a[substr($1,1,2)]+=1}END{for(i in a)printf "%d\t%d\n",i,a[i]}' ../data/id.txt>$DATA_PATH/person_province_${dd}.txt

#按投资金额划分和按投资笔数划分
awk 'BEGIN{}
{   
    if($2>=100 && $2<30000){
        money1++;}
    if($2>=30000 && $2<80000){
        money2++;}
    if($2>=80000 && $2<150000){    
        money3++;}
    if($2>=150000 && $2<500000){
        money4++;}
    if($2>=500000){
        money5++;}
    if($3>maxnumber){
        maxnumber=$3}
    if($3>=1 && $3<2){i
        n1++;}
    if($3>=2 && $3<5){
        n2++;}
    if($3>=5 && $3<10){
        n3++;}
    if($3>=10){
        n4++;}
}END{
    printf "%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n","num1",n1,"num2",n2,"num3",n3,"num4",n4,"account1",money1,"account2",money2,"account3",money3,"account4",money4,"account5",money5}' ../data/user.txt>>$DATA_PATH/week_${dd}.txt
#按年龄段划分
awk 'BEGIN{
    age1=0;
    age2=0;
    age3=0;
    age4=0;
    malecount=0;
    femalecount=0;
    year_now='`date +%Y`';
}{
    sex_id=substr($1,17,1);
    if(sex_id%2==1){
        malecount++;}
    if(sex_id%2==0){
        femalecount++;}
    year=substr($1,7,4);
    age=year_now-year;
    if(age>=18 && age<=29){
        age1++;}
    if(age>=30 && age<=39){
        age2++;}
    if(age>=40 && age<=49){
        age3++;}
    if(age>=50){
        age4++;}   
}END{
    printf "%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n%s\t%d\n","malecount",malecount,"femalecount",femalecount,"age1",age1,"age2",age2,"age3",age3,"age4",age4}' ../data/id.txt>>$DATA_PATH/week_${dd}.txt

awk '{printf "insert into itz_stat_total(k,v) values('"'"'"$1"'"'"','"'"'" $2 "'"'"')\t;"}' ../data/week_${dd}.txt>>$DATA_PATH/${dd}.txt
awk '{printf "insert into itz_stat_person values('"'"'" $1 "'"'"','"'"'" $2 "'"'"')\t;"}' ../data/person_province_${dd}.txt>>$DATA_PATH/${dd}.txt
