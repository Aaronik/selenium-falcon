// find text on the screen and click it

exports.command = function (content) {
  var browser = this;

  browser
    .useXpath()
    .click('//*[text()="' + content + '"]')
    .useCss();

  return browser;
}
