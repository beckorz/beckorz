#!/usr/local/bin/php
<?php
$die = array();
for ($i = 0; $i < 5; $i++) {
	array_push($die, mt_rand(1, 6));
}
$work = array_values($die);
sort($work);
$dice = join($work);
echo $dice."\n";

define('RE_YACHT', '/^([1-6])\1{4}$/');
define('RE_BIGSTRAIGHT', '/^1?23456?$/');
define('RE_LITTLESTRAIGHT', '/(1234|2345|3456)/');
define('RE_FOUROFAKIND', '/([1-6])\1{3}/');
define('RE_FULLHOUSE', '/(([1-6])\2([1-6])\3{2}|([1-6])\4{2}([1-6])\5)/');
define('RE_SIX', '/(6+)/');
define('RE_FIVE', '/(5+)/');
define('RE_FOUR', '/(4+)/');
define('RE_TREYS', '/(3+)/');
define('RE_DUCKS', '/(2+)/');
define('RE_ACE', '/(1+)/');

preg_match(RE_YACHT, $dice, $match_yacht);
preg_match(RE_BIGSTRAIGHT, $dice, $match_bigstraight);
preg_match(RE_LITTLESTRAIGHT, $dice, $match_littlestraight);
preg_match(RE_FOUROFAKIND, $dice, $match_fourofakind);
preg_match(RE_FULLHOUSE, $dice, $match_fullhouse);
preg_match(RE_SIX, $dice, $match_six);
/*
preg_match(RE_FIVE, $dice, $match_five);
preg_match(RE_FOUR, $dice, $match_four);
preg_match(RE_TREYS, $dice, $match_treys);
preg_match(RE_DUCKS, $dice, $match_ducks);
preg_match(RE_ACE, $dice, $match_ace);
*/
if ($match_yacht) {
	echo "Yacht\n";
	var_dump($match_yacht);
}
if ($match_bigstraight) {
	echo "Big Straight\n";
	var_dump($match_bigstraight);
}
if ($match_littlestraight) {
	echo "Little Straight\n";
	var_dump($match_littlestraight);
}
if ($match_fourofakind) {
	echo "Four Of A Kind\n";
	var_dump($match_fourofakind);
}
if ($match_fullhouse) {
	echo "Full House\n";
	var_dump($match_fullhouse);
}
if ($match_six) {
	echo "Six\n";
	var_dump($match_six);
}
/*
if ($match_five) {
	echo "Five\n";
	var_dump($match_five);
}
if ($match_four) {
	echo "Four\n";
	var_dump($match_four);
}
if ($match_treys) {
	echo "Treys\n";
	var_dump($match_treys);
}
if ($match_ducks) {
	echo "Ducks\n";
	var_dump($match_ducks);
}
if ($match_ace) {
	echo "Ace\n";
	var_dump($match_ace);
}
*/
?>
