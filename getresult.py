#!usr/bin/env python
#encoding:utf-8
import csv
import time

writer = open('result.txt','w')
user_reader = open('dw_borrow_tender.csv','rb')
h={}
count = 0
userDict = {}
totalcount = 0 
usercount1 = 0
usercount2 = 0
usercount3 = 0
usercount4 = 0
usercount5 = 0
usercount6 = 0
usercount7 = 0
usercount8 = 0
moneycount1 = 0
moneycount2 = 0
moneycount3 = 0
moneycount4 = 0
moneycount5 = 0
moneycount6 = 0
moneycount7 = 0
moneycount8 = 0
moneycount9 = 0
moneycount10 = 0
moneycount11 = 0
moneycount12 = 0
moneycount13 = 0
for line in user_reader:
    line = line.replace('"','')
    line = line.split(',')
    id = line[0]
    userid = line[2] 
    money = float(line[11])/10000
    status = int(line[3])
    if (status == 2):
        if not h.has_key(userid):
            h[userid]=1
            count += 1
        else:pass
    else:pass
    if userid in userDict:
        userDict[userid]['moneysum'] += money        
        userDict[userid]['usercount'] += 1
    else:
        userDict[userid] = {'moneysum':money,'usercount':1}
        totalcount += 1
for key in userDict.keys():
    if (userDict[key]['moneysum'] >= 1000):
        moneycount1 += 1
    if (userDict[key]['moneysum'] > 800 and userDict[key]['moneysum'] < 1000):
        moneycount2 += 1
    if (userDict[key]['moneysum'] > 500 and userDict[key]['moneysum'] <= 800):
        moneycount3 += 1
    if (userDict[key]['moneysum'] >= 300):
        moneycount4 += 1
    if (userDict[key]['moneysum'] >= 200):
        moneycount5 += 1
    if (userDict[key]['moneysum'] >= 100):
        moneycount6 += 1    
    if (userDict[key]['moneysum'] > 80 and userDict[key]['moneysum'] < 100):
        moneycount7 += 1
    if (userDict[key]['moneysum'] > 50 and userDict[key]['moneysum'] <= 80):
        moneycount8 += 1
    if (userDict[key]['moneysum'] > 40 and userDict[key]['moneysum'] <= 50):
        moneycount9 += 1
    if (userDict[key]['moneysum'] > 30 and userDict[key]['moneysum'] <= 40):
        moneycount10 += 1
    if (userDict[key]['moneysum'] > 20 and userDict[key]['moneysum'] <= 30):    
        moneycount11 += 1
    if (userDict[key]['moneysum'] > 10 and userDict[key]['moneysum'] <= 20):
        moneycount12 += 1
    if (userDict[key]['moneysum'] < 10):
        moneycount13 += 1
    else:pass

    if (userDict[key]['usercount'] == 1):
        usercount1 += 1
    if (userDict[key]['usercount'] == 2):
        usercount2 += 1
    if (userDict[key]['usercount'] > 2 and userDict[key]['usercount'] <= 5):
        usercount3 += 1
    if (userDict[key]['usercount'] > 5 and userDict[key]['usercount'] <= 8):
        usercount4 += 1
    if (userDict[key]['usercount'] > 8 and userDict[key]['usercount'] <= 10):
        usercount5 += 1
    if (userDict[key]['usercount'] > 10 and userDict[key]['usercount'] <= 12):
        usercount6 += 1
    if (userDict[key]['usercount'] > 12 and userDict[key]['usercount'] <= 15):
        usercount7 += 1
    if (userDict[key]['usercount'] > 15):
        usercount8 += 1
    else:pass
user_reader.close()

writer.writelines('投资总额1000万以上的人数:')
writer.write(str(moneycount1))
writer.write('\n')
writer.writelines('投资总额在800万以上1000万以下的人数:')
writer.write(str(moneycount2))
writer.write('\n')
writer.writelines('投资总额500万以上800万以下的人数:')
writer.write(str(moneycount3))
writer.write('\n')
writer.writelines('投资总额300万以上的人数:')
writer.write(str(moneycount4))
writer.write('\n')
writer.writelines('投资总额200万以上的人数:')
writer.write(str(moneycount5))
writer.write('\n')
writer.writelines('投资总额100万以上的人数:')
writer.write(str(moneycount6))
writer.write('\n')
writer.writelines('投资总额80万以上100万以下的人数:')
writer.write(str(moneycount7))
writer.write('\n')
writer.writelines('投资总额50万以上80万以下的人数:')
writer.write(str(moneycount8))
writer.write('\n')
writer.writelines('投资总额40万以上50万以下的人数:')
writer.write(str(moneycount9))
writer.write('\n')
writer.writelines('投资总额30万以上40万以下的人数:')
writer.write(str(moneycount10))
writer.write('\n')
writer.writelines('投资总额20万以上30万以下的人数:')
writer.write(str(moneycount11))
writer.write('\n')
writer.writelines('投资总额10万以上20万以下的人数:')
writer.write(str(moneycount12))
writer.write('\n')
writer.writelines('投资总额10万以下的人数:')
writer.write(str(moneycount13))
writer.write('\n')
writer.write('\n')

writer.writelines('投资笔数为1的人数:')
writer.write(str(usercount1))
writer.write('\n')
writer.write('投资笔数为2的人数:')
writer.write(str(usercount2))
writer.write('\n')
writer.write('投资笔数大于2小于等于5的人数:')
writer.write(str(usercount3))
writer.write('\n')
writer.write('投资笔数大于5小于等于8的人数:')
writer.write(str(usercount4))
writer.write('\n')
writer.write('投资笔数大于8小于等于10的人数:')
writer.write(str(usercount5))
writer.write('\n')
writer.write('投资笔数大于10小于等于12的人数:')
writer.write(str(usercount6))
writer.write('\n')
writer.write('投资笔数大于12小于等于15的人数:')
writer.write(str(usercount7))
writer.write('\n')
writer.write('投资笔数大于15的人数:')
writer.write(str(usercount8))
writer.write('\n')
writer.write('截止到目前的投资总人数:')
writer.write(str(totalcount))
writer.write('\n')
writer.write('\n')

credit_reader = open('dw_credit_log.csv','rb')
creditDict = {}
creditcount = 0
for line in credit_reader:
    line = line.replace('"','')
    line = line.split(',')
    userid = line[1]
    status = int(line[2])
    if (status == 17):
        if not creditDict.has_key(userid):
            creditcount += 1
        else:pass
    else:pass
credit_reader.close()
writer.write('得到过续投积分的人数:')
writer.write(str(creditcount))
writer.write('\n')
writer.write('截止到目前已经到期的项目数:')
writer.write(str(count))
writer.write('\n')
writer.write('\n')


debt_reader = open('dw_debt.csv','rb')
debtDict = {}
debt_count = 0
debt_sum = 0
income_sum = 0
for line in debt_reader:
    line = line.replace('"','')
    line = line.split(',')
    status = int(line[5])
    money = float(line[6])
    real_apr = float(line[13])
    if status == 2:
        debt_count += 1
        debt_sum += money
        income_sum += real_apr
    else:pass
average=income_sum/debt_count
debt_reader.close()
writer.write('成功转让债权数:')
writer.write(str(debt_count))
writer.write('\n')
writer.write('成功转让债权总额:')
writer.write(str(debt_sum))
writer.write('\n')
writer.write('成功转让后的平均收益:')
writer.write(str(round(average,2)))
writer.write('\n')
