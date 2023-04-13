#!/bin/bash
#配置文件


#月度页面和年度页面总开关  1--开启    2--关闭
#必须确保下面的参数全部存在于db中才能开启，否则会报错
mons_and_years_page_flag=1

#各个页面的地址（结尾不要带斜杠/）
management_page_url=https://www.test.com:8080


#月度页面(mons.html)8个折线图的数据（必须以 mon_ 开头）,改完后要同步一下数据
mon_param1=mon_good_sleep_days

mon_param2=mon_high_energy_days

mon_param3=ave_mon_day_income

mon_param4=ave_mon_day_focus_time

mon_param5=ave_mon_day_task_completed_num

mon_param6=mon_reading_days

mon_param7=mon_sport_days

mon_param8=mon_english_days



#年度页面(years.html)8个折线图的数据（必须以 year_ 开头），改完后要同步一下数据
year_param1=year_good_sleep_days

year_param2=year_high_energy_days

year_param3=ave_year_day_income

year_param4=ave_year_day_focus_time

year_param5=ave_year_day_task_completed_num

year_param6=year_reading_days

year_param7=year_sport_days

year_param8=year_english_days



#月度页面和年度页面八个折线图折点的颜色
line_chart_color1=DarkViolet

line_chart_color2=DarkCyan

line_chart_color3=OliveDrab

line_chart_color4=Fuchsia

line_chart_color5=DarkViolet

line_chart_color6=DarkCyan

line_chart_color7=OliveDrab

line_chart_color8=Fuchsia



#每日页面(index.html)、月度页面(mons.html)、年度页面(years.html)、本月页面(monSum.html)、今年页面(yearSum.html)、汇总页面(sum.html)的背景音乐
#这些背景音乐必须存在于 html/static/mp3 这个文件夹中，才能正常播放。在对应页面按Enter播放，再按一次暂停
#每日页面
daily_page_music="亲爱的旅人.mp3"

#月度页面
mons_page_music="再度重相逢.mp3"

#年度页面
years_page_music="挪威的森林.mp3"

#本月页面
monSum_page_music="所念皆星河.mp3"

#今年页面
yearSum_page_music="晴天.mp3"

#汇总页面
sum_page_music="流行的云.mp3"


#是否已经完成初次系统初始化  1--否   2--是
is_init_system=1

#初始化系统密钥,第一次初始化不需要
init_system_secret=439826577


