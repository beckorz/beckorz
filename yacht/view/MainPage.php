<?php
	$ses =& $this->session;
?>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Yacht</title>
</head>

<body>
Yacht 開始(｀･ω･´)<br>
<?= $ses->get(SESSION_SESSIONID_KEY) ?><br>
<?= $ses->get(SESSION_USERNAME_KEY) ?><br>
<?= $ses->get(SESSION_IP_KEY) ?><br>
<?= $ses->get(SESSION_STATE_KEY) ?><br>
<?= $ses->get(SESSION_DICES_KEY) ?><br>
</body>

</html>
