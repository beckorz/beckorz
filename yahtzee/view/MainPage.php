<?php
	$ses =& $this->session;
	$dice = $ses->get(SESSION_DICE_KEY);
?>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Yahtzee</title>
<link rel="stylesheet" type="text/css" href="res/common.css">
<script type="text/javascript" src="res/common.js"></script>
<script type="text/javascript" src="res/prototype.js"></script>
<script type="text/javascript" src="res/MainPage.js"></script>
</head>

<body>
<form id="MainForm">
	<input type="hidden" name="action" id="action" value="">

	<table>
		<tr>
			<th style="text-align:right">名前：</th>
			<td colspan="6"><?= htmlspecialchars($ses->get(SESSION_USERNAME_KEY)) ?></td>
		</tr>
		<tr>
			<th style="text-align:right">サイコロ：</th>
<?php
	for ($i = 0; $i < 5; $i++) {
		echo "\t\t\t<td align=\"center\">\n";
		echo "\t\t\t\t<div id=\"txtDie".$i."\">".$dice->getDie($i)."</div>\n";
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
		echo "\t\t\t\t<input type=\"checkbox\" name=\"chkDie".$i."\" id=\"chkDie".$i."\">\n";
		echo "\t\t\t</td>\n";
	}
?>
			<td align="right" colspan="6">
				<input type="button" id="btnRoll" value="振り直し">
			</td>
		</tr>
		<tr>
			<td colspan="7">
				<div id="txtMessage">サイコロを選んで振り直すか記録してください。</div>
			</td>
		</tr>
	</table>

	<table class="grid">
		<caption>スコアシート</caption>
		<tr>
			<th class="header">役名<br>成立条件</th>
			<th class="header">獲得点数</th>
			<th class="header">記録出目</th>
			<th class="header">記録点数</th>
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
				<tt><div id="txtDice0"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint0">0</div>
			</td>
			<td>
				<input type="button" id="btnScore0" value="記録">
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
				<tt><div id="txtDice1"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint1">0</div>
			</td>
			<td>
				<input type="button" id="btnScore1" value="記録">
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
				<tt><div id="txtDice2"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint2">0</div>
			</td>
			<td>
				<input type="button" id="btnScore2" value="記録">
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
				<tt><div id="txtDice3"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint3">0</div>
			</td>
			<td>
				<input type="button" id="btnScore3" value="記録">
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
				<tt><div id="txtDice4"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint4">0</div>
			</td>
			<td>
				<input type="button" id="btnScore4" value="記録">
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
				<tt><div id="txtDice5"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint5">0</div>
			</td>
			<td>
				<input type="button" id="btnScore5" value="記録">
			</td>
		</tr>
		<tr class="total">
			<th colspan="3">上段(エース〜シックス)合計</th>
			<td align="right">
				<div id="txtUpperTotal">0</div>
			</td>
			<td>&nbsp;</td>
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
				<tt>------</tt>
			</td>
			<td align="right">
				<div id="txtBonus">0</div>
			</td>
			<td>&nbsp;</td>
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
				<tt><div id="txtDice7"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint7">0</div>
			</td>
			<td>
				<input type="button" id="btnScore7" value="記録">
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
				<tt><div id="txtDice8"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint8">0</div>
			</td>
			<td>
				<input type="button" id="btnScore8" value="記録">
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
				<tt><div id="txtDice9"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint9">0</div>
			</td>
			<td>
				<input type="button" id="btnScore9" value="記録">
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
				<tt><div id="txtDice10"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint10">0</div>
			</td>
			<td>
				<input type="button" id="btnScore10" value="記録">
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
				<tt><div id="txtDice11"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint11">0</div>
			</td>
			<td>
				<input type="button" id="btnScore11" value="記録">
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
				<tt><div id="txtDice12"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint12">0</div>
			</td>
			<td>
				<input type="button" id="btnScore12" value="記録">
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
				<tt><div id="txtDice13"></div></tt>
			</td>
			<td align="right">
				<div id="txtPoint13">0</div>
			</td>
			<td>
				<input type="button" id="btnScore13" value="記録">
			</td>
		</tr>
		<tr class="total">
			<th colspan="3">下段(スリーダイス〜チャンス)合計</th>
			<td align="right">
				<div id="txtLowerTotal">0</div>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr class="total">
			<th colspan="3">合計(上段＋ボーナス＋下段)</th>
			<td align="right">
				<div id="txtGrandTotal">0</div>
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
</form>
<?php
// 以下、デバッグ用
echo "<pre>\n";
echo "−デバッグ情報−\n";
var_dump($_SESSION);
echo "</pre>\n";
?>
</body>

</html>
