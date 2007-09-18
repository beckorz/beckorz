<?php
	$res =& $this->response;
	$rankings = $res->get('rankings');
	$pubDate = $res->get('pubDate');
	header("Content-type: text/xml; charset=utf-8");
	echo '<?xml version="1.0" encoding="utf-8"?>' . "\n";
	echo '<?xml-stylesheet type="text/xsl" href="res/rss.xsl"?>' . "\n";
?>
<rss version="2.0">
	<channel>
		<title>Yahtzee ランキング</title>
		<link><?php echo RANKING_URL ?></link>
		<description>Yahtzee ランキング 上位15件</description>
		<pubDate><?php echo $pubDate ?></pubDate>
<?php
	for ($row = 0; $row < count($rankings) && $row < 15; $row++) {
		$ranking = $rankings[$row];
		$rank = ($row + 1);
		$point = $ranking->getPoint();
		$user = htmlspecialchars($ranking->getUser());
		$comment = htmlspecialchars($ranking->getComment());
		$date = date('r', $ranking->getDate());
		echo '
		<item rank="' . $rank . '" point="' . $point . '" user="' . $user . '">
			<title>' . $rank . '位 - ' . $point . ' - ' . $user . '</title>
			<description>' . $comment . '</description>
			<pubDate>' . $date . '</pubDate>
			<link>' . RANKING_URL . '</link>
		</item>';
	}
?>
	</channel>
</rss>
