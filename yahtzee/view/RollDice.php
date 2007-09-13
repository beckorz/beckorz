<?php
	$ses =& $this->session;
	$state = $ses->get(SESSION_STATE_KEY);
	$dice = $ses->get(SESSION_DICE_KEY);
?>
{
	  "state": "<?= $state ?>"
	, "dice": [<?= join(',', $dice->getDice()) ?>]
}
