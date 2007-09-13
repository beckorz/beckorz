<?php
	$res =& $this->response;
?>
{
	  "message": "<?= htmlspecialchars($res->get('message')) ?>"
	, "result": <?= $res->get('result') ?>
}
