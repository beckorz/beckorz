<?php
	$ses =& $this->session;
	$score = $ses->get(SESSION_SCORE_KEY);
	$dice = $ses->get(SESSION_DICE_KEY);
?>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Yacht</title>
</head>

<body>
Yacht 開始(｀･ω･´)<br>
セッションID：<?= $ses->get(SESSION_SESSIONID_KEY) ?><br>
名前：<?= htmlspecialchars($ses->get(SESSION_USERNAME_KEY)) ?><br>
IPアドレス：<?= $ses->get(SESSION_IP_KEY) ?><br>
状態：<?= $ses->get(SESSION_STATE_KEY) ?><br>
ヨットの状態：<?= var_dump($score->isScoredYacht()) ?><br>
ヨットの点数：<?= var_dump($score->getPointYacht()) ?><br>
サイコロの目：<?= $dice->toString() ?><br>
</body>

</html>
