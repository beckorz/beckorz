// for IE
/*@cc_on
var doc = document;
eval('var document = doc');
@*/

var manager = new CookieManager();
var reloader = new Reloader();
reloader.xmlPath = 'iCh@t.php';
reloader.xslPath = 'res/skins/default.xsl';
reloader.formId = 'mainForm';
reloader.statusId = 'status';
reloader.logId = 'log';
reloader.manager = manager;

setInterval('reloader.reload()', 5000);
