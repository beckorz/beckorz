<?php
	$req =& $this->request;
	$res =& $this->response;
	$user = ($_COOKIE['user']) ? $_COOKIE['user'] : $req->get('user');
	$user = htmlspecialchars($user);
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<title>Yahtzee ログイン</title>
<link rel="stylesheet" type="text/css" href="res/common.css">
<script type="text/javascript" src="res/common.js"></script>
<script type="text/javascript" src="res/prototype.js"></script>
</head>

<body onload="focusElement('LoginForm', 'user', true)">
<!-- サイコロ画像プリロードここから -->
<img src="res/die1.gif" width="0" height="0" alt="1" style="display:none">
<img src="res/die2.gif" width="0" height="0" alt="2"  style="display:none">
<img src="res/die3.gif" width="0" height="0" alt="3"  style="display:none">
<img src="res/die4.gif" width="0" height="0" alt="4"  style="display:none">
<img src="res/die5.gif" width="0" height="0" alt="5"  style="display:none">
<img src="res/die6.gif" width="0" height="0" alt="6"  style="display:none">
<!-- サイコロ画像プリロードここまで -->
<form name="LoginForm" action="index.php" method="post">
	<input type="hidden" name="action" value="Login">

	<?= $res->get(ERROR_MSG) ?>
	<table summary="ログイン">
		<tr>
			<th align="right">名前：</th>
			<td>
				<input type="text" name="user" maxlength="30" value="<?= $user ?>" style="width:150px">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<label><input type="checkbox" name="saveUser" value="1">クッキーに保存</label>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="ログイン">
			</td>
		</tr>
	</table>
</form>
</body>

</html>
