#!bin/bash
source ../conf/config.sh
#输出网站用户名，真实名字，邮箱，电话，注册时间
echo "set names 'utf8';select username,realname,email,phone,from_unixtime(addtime) from dw_user where user_src='cunzhe' and real_status=1 and addtime>=1396281600 and addtime<=1404143999" order by addtime|$MYSQL|awk '{if(NR>1)print}'>$DATA_PATH/cunzhe_user.txt
