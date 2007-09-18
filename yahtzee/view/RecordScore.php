<?php
	$ses =& $this->session;
	$res =& $this->response;
	$score = $ses->get(SESSION_SCORE_KEY);
	$dice = $ses->get(SESSION_DICE_KEY);
?>
{
	  "state": "<?php echo $ses->get(SESSION_STATE_KEY) ?>"
	, "turn": <?php echo $ses->get(SESSION_TURN_KEY) ?>
	, "point": <?php echo $res->get('point') ?>
	, "upperTotalPoint": <?php echo $score->getUpperTotalPoint() ?>
	, "bonusPoint": <?php echo $score->getBonusPoint() ?>
	, "lowerTotalPoint": <?php echo $score->getLowerTotalPoint() ?>
	, "grandTotalPoint": <?php echo $score->getGrandTotalPoint() ?>
	, "scoreDice": [<?php echo join(',', $res->get('dice')) ?>]
	, "dice": [<?php echo join(',', $dice->getDice()) ?>]
}
