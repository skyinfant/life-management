#!/bin/bash
#生成本月汇总数据页面

source ./funcs.sh

file="./html/monSum.html"

cat > $file <<EOF
<!DOCTYPE html>
<html>

<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Expires" content="0">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Cache-control" content="no-cache,must-revalidate">
        <meta http-equiv="Cache" content="no-cache">
        <link rel="icon" href="./static/logo.png">
        <title>$year年$mon_of_year月</title>

	<link rel="stylesheet" type="text/css" href="./static/css/one_level.css">
	<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>

	<style>
		p {
			font-size: 22px !important;

			width: 600px;
			height: 40px;
			/* 让块级元素水平居中 */
			margin: auto;
		}

		body {
			height: 100%;
			margin: 0;
			background-color: #CCFFFF;
		}
	</style>

</head>

<body onclick="reloadPage();">

	<!-- 背景音乐 -->
	<div id="music">

		<audio loop="true" id="bgm">
			<source src="./static/mp3/$monSum_page_music">
		</audio>

	</div>

	<section class="content">
		<div class="content_main" name="flag_start">


<br><br>
<p>睡眠质量好的天数：$mon_good_sleep_days</p>
<p>睡眠质量好的比例：$rate_mon_good_sleep_days</p>
<p>睡眠质量差的天数：$mon_bad_sleep_days</p>
<br><br>


<p>能量值：$mon_energy</p>
<p>能量值达到8以上天数：$mon_high_energy_days</p>
<p>能量值达到8以上比例：$rate_mon_high_energy_days</p>
<p>能量值小于8的天数：$mon_low_energy_days</p>
<p>每日平均能量值：$ave_mon_day_energy</p>
<br><br>


<p>入账额：$mon_income</p>
<p>收益达到8000以上天数：$mon_high_income_days</p>
<p>收益达到8000以上比例：$rate_mon_high_income_days</p>
<p>平均每日入账额：$ave_mon_day_income</p>
<br><br>


<p>focus时间(小时)：$mon_focus_time</p>
<p>focus达到10h以上天数：$mon_high_focus_days</p>
<p>focus达到10h以上比例：$rate_mon_high_focus_days</p>
<p>平均每日focus时间：$ave_mon_day_focus_time</p>
<br><br>


<p>完成任务数：$mon_task_completed_num</p>
<p>完成任务日速度：$ave_mon_day_task_completed_num</p>
<p>完成任务8个以上天数：$mon_high_task_days</p>
<p>完成任务8个以上比例：$rate_mon_high_task_days</p>
<br><br>


<p>运动天数：$mon_sport_days</p>
<p>运动比例：$rate_mon_sport_days</p>
<br><br>


<p>读书天数：$mon_reading_days</p>
<p>读书比例：$rate_mon_reading_days</p>
<br><br>


<p>学英语天数：$mon_english_days</p>
<p>学英语比例：$rate_mon_english_days</p>
<br><br>


<p>学习次数：$mon_study_times</p>
<br><br>


<p>玩游戏次数：$mon_play_game_times</p>
<br><br>


		</div name="flag_end">

	</section>


	<script>
		function reloadPage() {
			window.location.reload();
		}


		//背景音乐
		var bgm = document.getElementById('bgm');
		document.onkeydown = function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which;

			//回车播放或者暂停音乐
			if (code == 13) {
				if (bgm.paused) {
					bgm.play();
					return;
				} else {
					bgm.pause();
					return;
				}

			} else

				//2键打开今年汇总数据页面
				if (code == 50) {
					window.open('https://www.tomorrowcat.com/yearSum.html', '_blank');
				} else


					//3键打开汇总页面
					if (code == 51) {
						window.open('https://www.tomorrowcat.com/sum.html', '_blank');
					} else


						//4键打开最近24个月数据
						if (code == 52) {
							window.open('https://www.tomorrowcat.com/mons.html', '_blank');
						} else


							//5键打开历年数据
							if (code == 53) {
								window.open('https://www.tomorrowcat.com/years.html', '_blank');
							} else



							//其他任意键刷新页面
							{
								window.location.reload();
							}
		}



		//窗口激活则刷新页面
		\$(window).focus(function () {
			window.location.reload();
		});

	</script>
</body>

</html>
EOF



