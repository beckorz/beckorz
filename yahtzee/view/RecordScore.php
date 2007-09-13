<?php
	$ses =& $this->session;
	$res =& $this->response;
	$score = $ses->get(SESSION_SCORE_KEY);
	$dice = $ses->get(SESSION_DICE_KEY);
?>
{
	  "state": "<?= $ses->get(SESSION_STATE_KEY) ?>"
	, "turn": <?= $ses->get(SESSION_TURN_KEY) ?>
	, "point": <?= $res->get('point') ?>
	, "upperTotalPoint": <?= $score->getUpperTotalPoint() ?>
	, "bonusPoint": <?= $score->getBonusPoint() ?>
	, "lowerTotalPoint": <?= $score->getLowerTotalPoint() ?>
	, "grandTotalPoint": <?= $score->getGrandTotalPoint() ?>
	, "scoreDice": [<?= join(',', $res->get('dice')) ?>]
	, "dice": [<?= join(',', $dice->getDice()) ?>]
}
