/**
 * 画面の初期化
 *
 * @param dice 出目の配列
 */
function resetScreen(dice) {
	actionState(STATE_NOTROLLED, dice);
	for (var i = 0; i <= 13; i++) {
		$("txtDice" + i).innerHTML = "";
		$("txtPoint" + i).innerHTML = "0";
		$("txtTurn" + i).innerHTML = "";
		$("btnScore" + i).disabled = false;
	}
	$("txtUpperTotal").innerHTML = "0";
	$("txtLowerTotal").innerHTML = "0";
	$("txtGrandTotal").innerHTML = "0";
}

/**
 * セッションタイムアウト共通処理
 */
function onTimeoutAction(httpObj) {
	$("txtError").innerHTML = "セッションがタイムアウトしました。ログインしなおしてください。";
}

/**
 * サイコロの目を表示用に加工して返す
 *
 * @param die 表示するサイコロの目(1〜6)
 *
 * @return 加工された文字列
 */
function convertDie(die) {
	/*
		// テキスト版
		return die;
	/*/
		// 画像版
		return '<span class="die' + die + '" title="' + die + '"></span>';
	//*/
}

/**
 * 現在の出目を再表示して選択チェックをすべて外す
 *
 * @param dice 出目の配列
 */
function showDice(dice) {
	for (var i = 0; i < 5; i++) {
		$("txtDie" + i).innerHTML = convertDie(dice[i]);
		$("chkDie" + i).checked = false;
	}
}

/**
 * サイコロを振り直す
 */
function rollDice() {
	var onSuccessAction = function (httpObj) {
		var json = eval("(" + httpObj.responseText + ")");
		actionState(json.state, json.dice);
	}
	var onFailureAction = function (httpObj) {
		$("btnRoll").disabled = false;
	}
	var main = function () {
		// 選択されているサイコロがあるか？
		var selected = false;
		for (var i = 0; i < 5; i++) {
			if ($("chkDie" + i).checked) {
				selected = true;
				break;
			}
		}
		if (!selected) {
			alert("振り直すサイコロを選択してください。");
			return;
		}
		$("btnRoll").disabled = true;
		$("action").value = "RollDice";
		new Ajax.Request(REQUEST_URL, {
			  parameters: Form.serialize("MainForm")
			, onSuccess: onSuccessAction
			, onFailure: onFailureAction
			, on408: onTimeoutAction
		});
	}
	main();
}

/**
 * 役の成立判定
 *
 * @param index 役のインデックス
 */
function checkHand(index) {
	var onSuccessAction = function (httpObj) {
		var json = eval("(" + httpObj.responseText + ")");
		if (json.point == 0) {
			$("txtMessage").innerHTML = "間違って記録ボタンを押してしまっても振り直しはできません。";
			if (!confirm("役が成立していませんが記録していいですか？")) {
				$("btnScore" + index).disabled = false;
				return;
			}
		}
		recordScore(index);
	}
	var onFailureAction = function (httpObj) {
		$("btnScore" + index).disabled = false;
	}
	var main = function () {
		$("btnRoll").disabled = true;
		$("btnScore" + index).disabled = true;
		$("action").value = "CheckHand";
		$("hand").value = index;
		new Ajax.Request(REQUEST_URL, {
			  parameters: Form.serialize("MainForm")
			, onSuccess: onSuccessAction
			, onFailure: onFailureAction
			, on408: onTimeoutAction
		});
	}
	main();
}

/**
 * スコアを記録
 *
 * @param index 役のインデックス
 */
function recordScore(index) {
	var onSuccessAction = function (httpObj) {
		var json = eval("(" + httpObj.responseText + ")");
		var txtDice = "";
		for (var i = 0; i < 5; i++) {
			txtDice += convertDie(json.scoreDice[i]);
		}
		$("txtDice" + index).innerHTML = '<div class="dice">' + txtDice + '</div>';
		$("txtPoint" + index).innerHTML = json.point;
		$("txtTurn" + index).innerHTML = json.turn;
		$("txtUpperTotal").innerHTML = json.upperTotalPoint;
		$("txtPoint6").innerHTML = json.bonusPoint;
		$("txtLowerTotal").innerHTML = json.lowerTotalPoint;
		$("txtGrandTotal").innerHTML = json.grandTotalPoint;
		actionState(json.state, json.dice);
	}
	var onFailureAction = function (httpObj) {
		$("btnScore" + index).disabled = false;
	}
	var main = function () {
		$("action").value = "RecordScore";
		$("hand").value = index;
		new Ajax.Request(REQUEST_URL, {
			  parameters: Form.serialize("MainForm")
			, onSuccess: onSuccessAction
			, onFailure: onFailureAction
			, on408: onTimeoutAction
		});
	}
	main();
}

/**
 * 状態に応じた処理
 *
 * @param state 状態
 * @param dice 出目の配列
 */
function actionState(state, dice) {
	switch (state) {
		case STATE_NOTROLLED:
			showDice(dice);
			$("btnRoll").value = "振り直し1";
			$("btnRoll").disabled = false;
			$("txtMessage").innerHTML = "サイコロを選んで振り直すか記録してください。";
			break;
		case STATE_FIRST:
			showDice(dice);
			$("btnRoll").value = "振り直し2";
			$("btnRoll").disabled = false;
			$("txtMessage").innerHTML = "再度サイコロを選んで振り直すか記録してください。";
			break;
		case STATE_SECOND:
			showDice(dice);
			$("txtMessage").innerHTML = "(役が成立していなくても)スコアを記録してください。";
			break;
		case STATE_ALLSCORED:
			$("btnRoll").disabled = true;
			$("txtMessage").innerHTML = "ゲーム終了！";
			registerRanking();
			break;
	}
}

/**
 * ランキング登録処理
 */
function registerRanking() {
	var isRegister = 0;

	var onSuccessAction = function (httpObj) {
		var json = eval("(" + httpObj.responseText + ")");
		if (isRegister) {
			alert(json.message);
		}
		resetScreen(json.dice);
	}
	var onFailureAction = function (httpObj) {
		if (isRegister) {
			alert("ランキング登録に失敗しました。ごめんなさい(´･ω･｀)");
		}
	}
	var main = function () {
		$("action").value = "RegisterRanking";
		var totalPoint = $("txtGrandTotal").innerHTML
		if (confirm("合計得点：" + totalPoint + "\nランキングに登録しますか？")) {
			isRegister = 1;
			var comment = prompt("コメントをどうぞ。(" + RANKING_COMMENT_MAXLENGTH  + "文字まで)", "");
			$("comment").value = (comment != null) ? comment : "";
		} else {
			isRegister = 0;
		}
		$("register").value = isRegister;
		new Ajax.Request(REQUEST_URL, {
			  parameters: Form.serialize("MainForm")
			, onSuccess: onSuccessAction
			, onFailure: onFailureAction
			, on408: onTimeoutAction
		});
	}
	main();
}
