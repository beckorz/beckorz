<?php
// すべての要求を受け付けるメインスクリプト
require_once('defines.php');
require_once('model/Dice.php');
require_once('model/ScoreTable.php');
require_once('model/Ranking.php');
require_once('dao/RankingDAO.php');

require_once('Controller.php');
require_once('Request.php');
require_once('Session.php');
require_once('Response.php');

$request =& new Request();
$session =& new Session();
$response =& new Response();
$controller =& new Controller($request, $session, $response);

$controller->execute();
?>
