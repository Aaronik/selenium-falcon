exports.command = function (className) {
  var browser = this;
  var globals = browser.globals;

  browser
    .execute(function (className) {
      var node = document.querySelector(className);
      ReactTestUtilsForSelenium.Simulate.doubleClick(node);
    }, [className]);

  return browser
}
