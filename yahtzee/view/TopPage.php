<?php
	$req =& $this->request;
	$res =& $this->response;
?>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Yahtzee ログイン</title>
<link rel="stylesheet" type="text/css" href="res/common.css">
<script type="text/javascript" src="res/common.js"></script>
<script type="text/javascript" src="res/prototype.js"></script>
</head>

<body onload="focusElement('LoginForm', 'user')">
<form name="LoginForm" action="index.php" method="post">
	<input type="hidden" name="action" value="Login">

	<?= $res->get(ERROR_MSG) ?>
	<table>
		<tr>
			<th align="right">名前：</th>
			<td>
				<input type="text" name="user" width="20" maxlength="30" value="<?= htmlspecialchars($req->get('user')) ?>">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="submit" value="ログイン">
			</td>
		</tr>
	</table>
</form>
</body>

</html>
