#!bin/bash
source ../conf/config.sh

dd=`date -d"-1 day" +%Y%m%d`

#echo "$dd 统计数据“">data_${dd}.txt
#用户已投资
echo -n "sum_accountyes    ">>$DATA_PATH/day_${dd}.txt
echo "select sum(account_yes) from dw_borrow"|$MYSQL|awk '{if(NR>1)print}'  >>$DATA_PATH/day_${dd}.txt
#用户已赚利息
echo -n "sum_interest    ">>$DATA_PATH/day_${dd}.txt
echo "select sum(interest) from dw_borrow_tender"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/day_${dd}.txt
#已还本金
echo -n "repayment_yesaccount    ">>$DATA_PATH/day_${dd}.txt
echo "select sum(repayment_yesaccount-repayment_yesinterest) from dw_borrow_tender"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/day_${dd}.txt
#已还利息
echo -n "repayment_yesinterest    ">>$DATA_PATH/day_${dd}.txt
echo "select sum(repayment_yesinterest) from dw_borrow_tender"|$MYSQL|awk '{if(NR>1)print}'>>$DATA_PATH/day_${dd}.txt


awk '{printf "insert into itz_stat_day_invest values('\''"$1"'\'','\''"$2"'\'')\t;"}' ../data/day_${dd}.txt >$DATA_PATH/${dd}.txt
#awk '{printf "insert into itz_stat_total(k,v) values('"'"'"$1"'"'"','"'"'" $2 "'"'"')\t;"}' ../data/week_${dd}.txt>>$DATA_PATH/${dd}.txt
#awk '{printf "insert into itz_stat_person values('"'"'" $1 "'"'"','"'"'" $2 "'"'"')\t;"}' ../data/person_province_${dd}.txt>>$DATA_PATH/${dd}.txt

echo "source ../data/${dd}.txt;"|$MYSQL
