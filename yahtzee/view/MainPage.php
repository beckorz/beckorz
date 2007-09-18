<?php
	$url = $_SERVER['SCRIPT_NAME'];
	$ses =& $this->session;
	$dice = $ses->get(SESSION_DICE_KEY);
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<title>Yahtzee</title>
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<?php echo RANKING_URL ?>">
<link id="changecss" rel="stylesheet" type="text/css" href="res/default.css">
<script type="text/javascript" src="res/common.js"></script>
<script type="text/javascript" src="res/prototype.js"></script>
<script type="text/javascript"><!--
// 疑似定数宣言
RANKING_COMMENT_MAXLENGTH = <?php echo RANKING_COMMENT_MAXLENGTH ?>;
REQUEST_URL = "<?php echo $url ?>";
STATE_NOTROLLED = "<?php echo STATE_NOTROLLED ?>";
STATE_FIRST = "<?php echo STATE_FIRST ?>";
STATE_SECOND = "<?php echo STATE_SECOND ?>";
STATE_ALLSCORED = "<?php echo STATE_ALLSCORED ?>";
// --></script>
<script type="text/javascript" src="res/MainPage.js"></script>
</head>

<body onload="resetScreen([<?php echo join(',', $dice->getDice()) ?>])">
<div id="csschange">
<a id="css1" title="default" onclick="replace_css('1', 'changecss', 'res/default.css'); ">■</a>
<a id="css2" title="flat" onclick="replace_css('2', 'changecss', 'res/flat.css');">□</a>
</div>
<form id="MainForm" action="<?php echo $url ?>">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="hand" id="hand" value="">
	<input type="hidden" name="register" id="register" value="">
	<input type="hidden" name="comment" id="comment" value="">

	<table summary="情報">
		<tr>
			<th style="text-align:right">名前：</th>
			<td colspan="6"><?php echo htmlspecialchars($ses->get(SESSION_USERNAME_KEY)) ?></td>
		</tr>
		<tr>
			<th style="text-align:right">サイコロ：</th>
<?php
	for ($i = 0; $i < 5; $i++) {
		echo "\t\t\t<td align=\"center\">\n";
		echo "\t\t\t\t<tt id=\"txtDie".$i."\">&nbsp;</tt>\n";
		echo "\t\t\t</td>\n";
	}
?>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<th style="text-align:right">選択：</th>
<?php
	for ($i = 0; $i < 5; $i++) {
		echo "\t\t\t<td align=\"center\">\n";
		echo "\t\t\t\t<input type=\"checkbox\" name=\"chkDie".$i."\" id=\"chkDie".$i."\" value=\"1\">\n";
		echo "\t\t\t</td>\n";
	}
?>
			<td align="right">
				<input type="button" id="btnRoll" value="振り直し1" onclick="rollDice()">
			</td>
		</tr>
	</table>
	<div id="txtMessage">サイコロを選んで振り直すか記録してください。</div>
	<div id="txtError" class="attention">&nbsp;</div>

	<table class="grid" summary="スコアシート">
		<caption>スコアシート</caption>
		<tr>
			<th class="header">役名<br>成立条件</th>
			<th class="header">獲得点数</th>
			<th class="header">記録出目</th>
			<th class="header">記録点数</th>
			<th class="header">記録順</th>
			<th class="header">&nbsp;</th>
		</tr>
		<tr>
			<th>
				エース<br>
				　なし
			</th>
			<th style="text-align:right">
				1の目の合計
			</th>
			<td align="center">
				<tt id="txtDice0">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint0">0</div>
			</td>
			<td align="right">
				<div id="txtTurn0">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore0" value="記録" onclick="checkHand(0)">
			</td>
		</tr>
		<tr>
			<th>
				ツー<br>
				　なし
			</th>
			<th style="text-align:right">
				2の目の合計
			</th>
			<td align="center">
				<tt id="txtDice1">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint1">0</div>
			</td>
			<td align="right">
				<div id="txtTurn1">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore1" value="記録" onclick="checkHand(1)">
			</td>
		</tr>
		<tr>
			<th>
				スリー<br>
				　なし
			</th>
			<th style="text-align:right">
				3の目の合計
			</th>
			<td align="center">
				<tt id="txtDice2">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint2">0</div>
			</td>
			<td align="right">
				<div id="txtTurn2">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore2" value="記録" onclick="checkHand(2)">
			</td>
		</tr>
		<tr>
			<th>
				フォー<br>
				　なし
			</th>
			<th style="text-align:right">
				4の目の合計
			</th>
			<td align="center">
				<tt id="txtDice3">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint3">0</div>
			</td>
			<td align="right">
				<div id="txtTurn3">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore3" value="記録" onclick="checkHand(3)">
			</td>
		</tr>
		<tr>
			<th>
				ファイブ<br>
				　なし
			</th>
			<th style="text-align:right">
				5の目の合計
			</th>
			<td align="center">
				<tt id="txtDice4">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint4">0</div>
			</td>
			<td align="right">
				<div id="txtTurn4">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore4" value="記録" onclick="checkHand(4)">
			</td>
		</tr>
		<tr>
			<th>
				シックス<br>
				　なし
			</th>
			<th style="text-align:right">
				6の目の合計
			</th>
			<td align="center">
				<tt id="txtDice5">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint5">0</div>
			</td>
			<td align="right">
				<div id="txtTurn5">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore5" value="記録" onclick="checkHand(5)">
			</td>
		</tr>
		<tr class="total">
			<th colspan="3">上段(エース〜シックス)合計</th>
			<td align="right">
				<div id="txtUpperTotal">0</div>
			</td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr class="total">
			<th>
				ボーナス<br>
				　上段合計が63点以上
			</th>
			<th style="text-align:right">
				35
			</th>
			<td align="center">
				<tt id="txtDice6">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint6">0</div>
			</td>
			<td colspan="2">
				<div id="txtTurn6">&nbsp;</div>
				<input type="button" id="btnScore6" value="記録" style="display:none">
			</td>
		</tr>
		<tr>
			<th>
				スリーダイス<br>
				　同じ目が3つ以上
			</th>
			<th style="text-align:right">
				5つの目の合計
			</th>
			<td align="center">
				<tt id="txtDice7">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint7">0</div>
			</td>
			<td align="right">
				<div id="txtTurn7">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore7" value="記録" onclick="checkHand(7)">
			</td>
		</tr>
		<tr>
			<th>
				フォーダイス<br>
				　同じ目が4つ以上
			</th>
			<th style="text-align:right">
				5つの目の合計
			</th>
			<td align="center">
				<tt id="txtDice8">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint8">0</div>
			</td>
			<td align="right">
				<div id="txtTurn8">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore8" value="記録" onclick="checkHand(8)">
			</td>
		</tr>
		<tr>
			<th>
				フルハウス<br>
				　同じ目が3つと2つの組
			</th>
			<th style="text-align:right">
				25
			</th>
			<td align="center">
				<tt id="txtDice9">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint9">0</div>
			</td>
			<td align="right">
				<div id="txtTurn9">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore9" value="記録" onclick="checkHand(9)">
			</td>
		</tr>
		<tr>
			<th>
				スモールストレート<br>
				　長さ4以上の連番
			</th>
			<th style="text-align:right">
				30
			</th>
			<td align="center">
				<tt id="txtDice10">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint10">0</div>
			</td>
			<td align="right">
				<div id="txtTurn10">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore10" value="記録" onclick="checkHand(10)">
			</td>
		</tr>
		<tr>
			<th>
				ラージストレート<br>
				　12345または23456
			</th>
			<th style="text-align:right">
				40
			</th>
			<td align="center">
				<tt id="txtDice11">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint11">0</div>
			</td>
			<td align="right">
				<div id="txtTurn11">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore11" value="記録" onclick="checkHand(11)">
			</td>
		</tr>
		<tr>
			<th>
				ヤッツィー<br>
				　すべて同じ目
			</th>
			<th style="text-align:right">
				50
			</th>
			<td align="center">
				<tt id="txtDice12">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint12">0</div>
			</td>
			<td align="right">
				<div id="txtTurn12">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore12" value="記録" onclick="checkHand(12)">
			</td>
		</tr>
		<tr>
			<th>
				チャンス<br>
				　なし
			</th>
			<th style="text-align:right">
				5つの目の合計
			</th>
			<td align="center">
				<tt id="txtDice13">&nbsp;</tt>
			</td>
			<td align="right">
				<div id="txtPoint13">0</div>
			</td>
			<td align="right">
				<div id="txtTurn13">&nbsp;</div>
			</td>
			<td>
				<input type="button" id="btnScore13" value="記録" onclick="checkHand(13)">
			</td>
		</tr>
		<tr class="total">
			<th colspan="3">下段(スリーダイス〜チャンス)合計</th>
			<td align="right">
				<div id="txtLowerTotal">0</div>
			</td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr class="total">
			<th colspan="3">合計(上段＋ボーナス＋下段)</th>
			<td align="right">
				<div id="txtGrandTotal">0</div>
			</td>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
<ul>
	<li><a href="http://gugurekasu.com/" target="_blank">遊び方</a></li>
	<li><a href="<?php echo $url ?>?action=ShowRanking" target="_blank">ランキング</a></li>
</ul>
</body>

</html>
