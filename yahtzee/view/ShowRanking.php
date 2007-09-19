<?php
	$res =& $this->response;
	$rankings = $res->get('rankings');
	$css = ($_COOKIE['css']) ? $_COOKIE['css'] : DEFAULT_CSS_PATH;

/**
 * 明細表示
 * 
 * @param $ranking Rankingデータ
 */
function showDetail($ranking) {
	$diceArray = $ranking->getDice();
	$turnArray = $ranking->getTurn();
	$count = 0;
	for ($row = 0; $row < count($diceArray); $row++) {
		$showDetail = true;
		switch ($row) {
			case TABLE_ACES:
				$hand = 'エース';
				break;
			case TABLE_TWOS:
				$hand = 'ツー';
				break;
			case TABLE_THREES:
				$hand = 'スリー';
				break;
			case TABLE_FOURS:
				$hand = 'フォー';
				break;
			case TABLE_FIVES:
				$hand = 'ファイブ';
				break;
			case TABLE_SIXES:
				$hand = 'シックス';
				break;
			case TABLE_THREEOFAKIND:
				$hand = 'スリーダイス';
				break;
			case TABLE_FOUROFAKIND:
				$hand = 'フォーダイス';
				break;
			case TABLE_FULLHOUSE:
				$hand = 'フルハウス';
				break;
			case TABLE_SMALLSTRAIGHT:
				$hand = 'スモールストレート';
				break;
			case TABLE_LARGESTRAIGHT:
				$hand = 'ラージストレート';
				break;
			case TABLE_YAHTZEE:
				$hand = 'ヤッツィー';
				break;
			case TABLE_CHANCE:
				$hand = 'チャンス';
				break;
			default:
				$showDetail = false;
				break;
		}
		if (!$showDetail) continue;
		$rowClass = (($count % 2) == 0) ? 'odd' : 'even';
		$count++;
		$diceStr = '';
		$dice = $diceArray[$row];
		for ($i = 0; $i < 5; $i++) {
			$die = $dice[$i];
			$diceStr .= '<img width="20" height="20" src="res/die' . $die . '.gif" alt="' . $die . '">';
		}
		$turnStr = $turnArray[$row];
		echo '
<tr class="' . $rowClass . '">
	<th>' . $hand . '</th>
	<td align="center"><tt>' . $diceStr . '&nbsp;</tt></td>
	<td align="right">' . $turnStr . '&nbsp;</td>
</tr>
';
	}
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<title>Yahtzee ランキング</title>
<link id="changecss" rel="stylesheet" type="text/css" href="<?php echo $css ?>">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<?php echo RANKING_URL ?>">
<script type="text/javascript" src="res/common.js"></script>
<script type="text/javascript" src="res/prototype.js"></script>
<script type="text/javascript"><!--
function toggleDetail(id) {
	$(id).style.display = ($(id).style.display == "none") ? "" : "none";
}
addEventHandler(window, "load", addCssLinks);
// --></script>
</head>

<body>
※行クリックで明細表示
　<a href="<?php echo RANKING_URL ?>"><img src="res/rss.gif" alt="ランキング上位のRSS" border="0"></a>
<table class="ranking" summary="ランキング">
	<caption>ランキング</caption>
	<tr>
		<th class="header" rowspan="2">No</th>
		<th class="header">名前</th>
		<th class="header">点数</th>
		<th class="header">日時</th>
	</tr>
	<tr>
		<th class="header" colspan="3" style="text-align:left">コメント</th>
	</tr>
<?php
	for ($row = 0; $row < count($rankings); $row++) {
		$rowClass = (($row % 2) == 0) ? 'odd' : 'even';
		$ranking = $rankings[$row];
?>
	<tr style="cursor:pointer" class="<?php echo $rowClass ?>" onclick="toggleDetail('no<?php echo $row ?>')">
		<th rowspan="2" style="text-align:right">
			<?php echo $row + 1 ?>
		</th>
		<td>
			<?php echo htmlspecialchars($ranking->getUser()) ?>
		</td>
		<td align="right">
			<?php echo $ranking->getPoint() ?>
		</td>
		<td align="center">
			<tt><?php echo date('Y/m/d H:i:s', $ranking->getDate()) ?></tt>
		</td>
	</tr>
	<tr style="cursor:pointer" class="<?php echo $rowClass ?>" onclick="toggleDetail('no<?php echo $row ?>')">
		<td colspan="3">
			<?php echo htmlspecialchars($ranking->getComment()) ?>&nbsp;
		</td>
	</tr>
	<tr style="display:none" id="no<?php echo $row ?>">
		<td>&nbsp;</td>
		<td colspan="4" align="center">
			<table class="detail" summary="明細" width="100%">
				<tr>
					<th class="header">役名</th>
					<th class="header">記録出目</th>
					<th class="header">記録順</th>
				</tr>
				<?php showDetail($ranking) ?>
			</table>
		</td>
	</tr>
<?php
	}
?>
</table>
<div id="cssLinks">□</div>
</body>

</html>
