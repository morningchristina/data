#!/bin/bash
source ../conf/config.sh

echo "select a.count1/b.count2 from (select count(user_id) as count1 from dw_credit_log where type_id=17) a ,(select count(distinct user_id) as count2 from dw_borrow_tender where status=2)b"|$MYSQL|awk '{if(NR>1)print}'

#echo "select count(distinct user_id),sum(amount) from dw_coupon"|$MYSQL|awk '{if(NR>1)print}'>coupon.txt
