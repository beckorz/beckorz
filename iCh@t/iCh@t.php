<?
/**
 * メインスクリプト
 */
require_once('defines.php');
require_once('Log.php');
require_once('LogDAO.php');
require_once('MakeTrip.php');

// リクエスト処理
$req = null;
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	$req =& $_GET;
} else {
	$req =& $_POST;
}
$dao = new LogDAO();
$logs = array();
$msg = mb_substr($req['msg'], 0, MSG_MAXLENGTH);
if ($msg == '') {
	$logs = $dao->getLogs();
} else {
	$user = $req['hn'];
	if ($user == '') {
		$user = HN_DEFAULT;
	}
	$trip = makeTrip($req['tripKey']);
	$log = new Log($user, $trip, $msg);
	$logs = $dao->addLog($log);
	setcookie('trip', $trip, time() + 60*60*24*30);
}

if (!file_exists(LOG_SAVE_PATH)) {
	$date = time();
} else {
	$date = filemtime(LOG_SAVE_PATH);
}
$pubDate = date('r', $date);
header('Content-type: application/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="utf-8"?>' . "\n";
/* echo '<?xml-stylesheet type="text/xsl" href="res/skins/default.xsl"?>' . "\n"; */
?>
<rss version="2.0">
	<channel>
		<title>iCh@t Log</title>
		<link>http://star.uiui.net/iCh@t/</link>
		<description>iCh@t Log</description>
		<pubDate><?php echo $pubDate ?></pubDate>
<?php
	for ($i = 0; $i < count($logs); $i++) {
		$log = $logs[$i];
		$user = htmlspecialchars($log->getUser(), ENT_QUOTES);
		$trip = htmlspecialchars($log->getTrip(), ENT_QUOTES);
		$category = $user;
		if ($trip != '') {
			$category .= '◆' . $trip;
		}
		$msg = htmlspecialchars($log->getMsg(), ENT_QUOTES);
		$date = date('r', $log->getDate());
		$formatDate = date('Y/m/d(D) H:i:s', $log->getDate());
		$md5 = md5($user . "\t" . $trip . "\t" . $msg . "\t" . $date);
		echo '
		<item hn="' . $user . '" trip="' . $trip . '" date="' . $formatDate . '">
			<title>' . $msg . '</title>
			<link>http://star.uiui.net/iCh@t/</link>
			<category>' . $category . '</category>
			<pubDate>' . $date . '</pubDate>
			<guid isPermaLink="false">' . $md5 . '</guid>
		</item>';
	}
?>
	</channel>
</rss>
