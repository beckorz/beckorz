<?php
require_once('Action.php');

/**
 * ��󥭥�ɽ�������Υ�������󥯥饹
 */
class ShowRankingAction extends Action {
	/** ���󥹥ȥ饯�� */
	function ShowRankingAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** �ꥯ�����Ȥ�������ƥ쥹�ݥ󥹤򥻥å� */
	function doExecute() {
		$res =& $this->response;
		
		// ��󥭥󥰾�������
		$dao = new RankingDAO();
		$rankings = $dao->getRankings();
		$res->set('rankings', $rankings);

		return PAGE_SUCCESS;
	}

	/** ���å��������� */
	function requireSession() {
		return false;
	}
}
?>
