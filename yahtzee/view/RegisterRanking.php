<?php
	$ses =& $this->session;
	$res =& $this->response;
	$dice = $ses->get(SESSION_DICE_KEY);
?>
{
	  "message": "<?php echo htmlspecialchars($res->get('message')) ?>"
	, "dice": [<?php echo join(',', $dice->getDice()) ?>]
}
