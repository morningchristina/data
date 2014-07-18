#!/usr/bin/env python
#encoding:utf-8
import csv
import time

lines=open('dw_user.csv','rb')
userDict = {}
for line in lines:
    line=line.replace('"','')
    line=line.split(',')
    user_id =line[0]
    logintime =line[55]
    userDict.setdefault(user_id,logintime)

reader=open('dw_borrow_tender.csv','rb')
writer=open('result.txt','w')
Dict = {}
h={}
firstbig=0
firstsmall=0
sign_in_big=0
sign_in_small=0
totalseconds=0
newinvest=0
big_flag=False
small_flag=False
for line in reader:
    line=line.replace('"','')
    line=line.split(',')
    id = line[0]
    userid = line[2]
    money = float(line[11])
    datearray=line[21]
    if datearray=='NULL':
        pass
    else:
        if userid in userDict.keys():
            if (userDict[userid] != 'NULL'):
                totalseconds = float(datearray)-float(userDict[userid])
            else:pass
        else:pass
        format1='%Y-%m-%d'
        value1=time.localtime(float(datearray))
        addtime=time.strftime(format1,value1)
    if addtime in Dict:
        Dict[addtime]['money'] += money
        Dict[addtime]['idcount'] += 1
        if (money >= 10000):
            Dict[addtime]['bigcount'] += 1
        else:
            Dict[addtime]['smallcount'] += 1
        if userDict.has_key(userid):
            if not h.has_key(userid):
                h[userid]=1
                Dict[addtime]['totalseconds'] += totalseconds
                Dict[addtime]['newinvest'] += 1
                if (money>=10000):
                    Dict[addtime]['firstbig'] += 1
                else:
                    Dict[addtime]['firstsmall'] += 1
            else:pass
        else:
            Dict[addtime]['totalseconds'] += totalseconds
            Dict[addtime]['newinvest'] += 1
            if (money>=10000):
                Dict[addtime]['sign_in_big'] += 1
            else:pass 
    else:
        if (money >= 10000):
            Dict[addtime] = {'firstbig':firstbig,'firstsmall':firstsmall,'newinvest':newinvest,'totalseconds':totalseconds,'idcount':1,'money':money,'bigcount':1,'smallcount':0,'sign_in_big':sign_in_big,'sign_in_small':sign_in_small}
        else:
            Dict[addtime] = {'firstbig':firstbig,'firstsmall':firstsmall,'newinvest':newinvest,'totalseconds':totalseconds,'idcount':1,'money':money,'bigcount':0,'smallcount':1,'sign_in_big':sign_in_big,'sign_in_small':sign_in_small}
        
        if userDict.has_key(userid):
            if not h.has_key(userid):
                h[userid]=1
                Dict[addtime]['totalseconds'] += totalseconds
                Dict[addtime]['newinvest'] += 1
                if (money>=10000):
                    Dict[addtime]['firstbig'] += 1
                else:
                    Dict[addtime]['firstsmall'] += 1
            else:pass
        else:
            Dict[addtime]['totalseconds'] += totalseconds
            Dict[addtime]['newinvest'] += 1
            if (money>=10000):
                Dict[addtime]['sign_in_big'] += 1
            else:
                Dict[addtime]['sign_in_small'] += 1
          
keys=Dict.keys()
keys.sort()
for key in keys: 
    writer.write('日期:')
    writer.write(key)
    writer.write('\n')
    writer.write('投资总额:')
    writer.write(str(Dict[key]['money']))
    writer.write('\n')
    writer.write('投资人数:')
    writer.write(str(Dict[key]['idcount']))
    writer.write('\n')
    writer.write('投资总人次大额:')
    writer.write(str(Dict[key]['bigcount']))
    writer.write('\n')
    writer.write('投资总人次小额:')
    writer.write(str(Dict[key]['smallcount']))
    writer.write('\n')
    writer.write('当天首次大额人次:')
    writer.write(str(Dict[key]['firstbig']))
    writer.write('\n')
    writer.write('当天首次小额人次:')
    writer.write(str(Dict[key]['firstsmall']))
    writer.write('\n')
    writer.write('当天注册并投资大额人次:')
    writer.write(str(Dict[key]['sign_in_big']))
    writer.write('\n')
    writer.write('当天注册并投资小额人次:')
    writer.write(str(Dict[key]['sign_in_small']))
    writer.write('\n')
    writer.write('新投资人数注册到投资平均天数:')
    if (Dict[key]['newinvest']!=0):
        writer.write(str((Dict[key]['totalseconds']/3600/24)/Dict[key]['newinvest']))
    else:
        writer.write('0')
    writer.write('\n')
    writer.write('\n')
reader.close()
