<?php
/**
 * ���������ִ������饹
 */
class Score {
	var $scored = array();
	var $point = array();

	/** ���󥹥ȥ饯�� */
	function Score() {
		// ���ƤΥ��������֤�̤����ˤ���������0�˽����
		for ($i = 0; $i < 12; $i++) {
			array_push($this->scored, false);
			array_push($this->point, 0);
		}
	}

	/** ��åȤΥ��������֤�������getter/setter */
	function isScoredYacht() {
		return $this->scored[0];
	}
	function setScoredYacht($scored) {
		$this->scored[0] = $scored;
	}
	function getPointYacht() {
		return $this->point[0];
	}
	function setPointYacht($point) {
		$this->point[0] = $point;
	}
	
	// TODO �ʲ���¾�����getter/setter����
}
