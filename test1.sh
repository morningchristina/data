#!/bin/bash
source ../conf/config.sh

echo "create table data_total (total_investment float,total_interest float,repayment_yesaccount float,repayment_yesinterest float,renewal_rate float,apr float,male float,female float,age1 float,age2 float,age3 float,age4 float,most_investment float,most_frequency float,most_renewal float,transfer_numbers float,transfer_money float,beforetransfer float,aftertransfer float,num1 int,num2 int,num3 int,num4 int,money1 float,money2 float,money3 float,money4 float,coupon_user int,coupon_money float)"|$MYSQL
echo "create table data_month_info (date float,money float,guarantor_number int)"|$MYSQL
echo "create table data_guarantor(city int,number int)"|$MYSQL

echo "select sum(account),sum(interest),sum(repayment_yesaccount-repayment_yesinterest),sum(repayment_yesinterest) from dw_borrow_tender"|$MYSQL|awk '{if(NR>1)print}' >total.txt
echo "select count(id),sum(apr) from dw_borrow "|$MYSQL|awk '{if(NR>1)print}' >profit.txt
echo "select from_unixtime(addtime,'%Y%m') as time,sum(account_yes) from dw_borrow where 1 group by time"|$MYSQL|awk '{if(NR>1)print}'>total_by_month.txt
echo "select user_id,sum(account),count(1) from dw_borrow_tender group by user_id"|$MYSQL|awk '{if(NR>1)print}' >user.txt
echo "select distinct card_id from dw_borrow_tender left join dw_user on dw_borrow_tender.user_id=dw_user.user_id where real_status=1"|$MYSQL|awk '{if(NR>1)print}' >id.txt
echo "select user_id,count(1) from dw_credit_log where type_id=17 group by user_id"|$MYSQL|awk '{if(NR>1)print}' >credit.txt 
echo "select a.count1/b.count2 from (select count(user_id) as count1 from dw_credit_log where type_id=17) a ,(select count(distinct user_id) as count2 from dw_borrow_tender where status=2)b"|$MYSQL|awk '{if(NR>1)print}'>credit_info.txt
echo "select count(distinct user_id),sum(money) from dw_debt where status=2"|$MYSQL|awk '{if(NR>1)print}'>debt_money.txt
echo "select dw_debt.id,apr,real_apr_b from dw_debt left join dw_borrow on dw_borrow.id=dw_debt.borrow_id"|$MYSQL|awk '{if(NR>1)print}' >debt_transfer.txt
echo "select from_unixtime(addtime,'%Y%m') as time,count(gid) from dw_guarantor_new where status=2 group by time"|$MYSQL|awk '{if(NR>1)print}' >guarantor.txt
echo "select distinct city,count(city) from dw_guarantor_new group by city"|$MYSQL|awk '{if(NR>1)print}' >guarantor_city.txt
echo "select count(distinct user_id),sum(amount) from dw_coupon"|$MYSQL|awk '{if(NR>1)print}'>coupon.txt

awk '{printf "insert into data_total (total_investment,total_interest,repayment_yesaccount,repayment_yesinterest) values(%s,%s,%s,%s)\n",$1,$2,$3,$4}' total.txt|$MYSQL
awk '{max=max>$2?max:$2}END{printf "insert into data_total(monst_renewal) values(%s)\n",$max}' credit.txt |$MYSQL
awk '{printf "insert into data_total (apr) values(%s)\n",$2/$1}' profit.txt|$MYSQL
awk '{printf "insert into data_total (transfer_numbers,transfer_money) values(%s,%s)\n",$1,$2}' debt_money.txt|$MYSQL
awk 'BEGIN{!a[$2]++}{a[substr($1,1,2)]+=1}END{for(i in a)printf("%s %d\n",i,a[i])}' id.txt|sort -rn -k2|head -5>province.txt
awk '{printf "insert into data_total (coupon_user,coupon_money)printf("%s %d\n",$1,$2}'coupon.txt |$MYSQL
awk '{printf "insert into data_total (renewal_rate) values(%s)\n",$1}'credit_info.txt |$MYSQL 
awk 'BEGIN{
    count1=0;
    count2=0;
    count3=0;
    count4=0;
    count5=0;
    n1=0;
    n2=0;
    n3=0;
    n4=0;
    maxmoney=0;
    maxnumber=0;
}
{   
    if($2>maxmoney){
        maxmoney=$2;}
    if($2>=100 && $2<30000){
        count1++;}
    if($2>=30000 && $2<80000){
        count2++;}
    if($2>=80000 && $2<150000){    
        count3++;}
    if($2>=150000 && $2<500000){
        count4++;}
    if($2>=500000){
        count5++;}
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
    printf "insert into data_total(most_investment,most_frequency,num1,num2,num3,num4,money1,money2,money3,money4) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)\n",$maxmoney,$maxnumber,$n1,$n2,$n3,$n4,$count1,$count2,$count3,$count4,$count5}' user.txt|$MYSQL

awk 'BEGIN{
    b4sum=0
    aftersum=0
    count=0
}{
    if($1){
        count++;
        b4sum+=$2;
        aftersum+=$3;
    }
}END{
    average1=b4sum/count;
    average2=after/count;
    printf "insert into data_total(beforetransfer,aftertransfer) values(%s,%s)\n",$average1,$average2}' debt_info.txt|$MYSQL
awk 'BEGIN{
    count=0;
    malecount=0;
    femalecount=0;
    twenty=0;
    thirty=0;
    forty=0;
    fifty=0;
    year_now='`date +%Y`'
}{
    if($1=1){
        count++;
        malecount++;}
    if($1=2){
        count++;
        femalecount++;}
    year=substr($1,7,4);
    age=year_now-year;
    if(age>=18 && age<=29){
        twenty++;}
    if(age>=30 && age<=39){
        thirty++;}
    if(age>=40 && age<=49){
        forty++;}
    if(age>=50){
        fifty++;}
    
}END{          
    malepercent=malecount/count;
    femalepercent=femalecount/count;
    printf "insert into data_total(male,female,age1,age2,age3,age4) values(%s,%s,%s,%s,%s,%s)\n",$malepercent,$femalepercent,$twenty,$thirty,$forty,$fifty}' id.txt|$MYSQL
awk 'BEGIN{
    count=0;
    renew_count=0;
    average=0;
}{
    if($1){
        count++;
        if($2==17){
            renew_count++}
    }
}END{
    average=renew_count/count;
    printf "insert into data_total(renewal_rate) values(%s)\n",$average}' credit_info.txt
echo "load data local infile 'total_by_month.txt' into data_month_info"|$MYSQL
echo "load data local infile 'guarantor.txt' into data_month_info"|$MYSQL
echo "load data local infile 'guarantor_city.txt' into data_guarantor"|$MYSQL 
