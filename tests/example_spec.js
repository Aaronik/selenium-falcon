module.exports = {
  tags: ['tag1', 'tag2'],

  "Explain your spec here": function (browser) {

    var ui = {
      define: '.specific',
      ui: '.elements',
      here: '.horray!'
    };

    browser
      .signin() // for example. If you want this to be real, make it in helpers!
      .waitForElementVisible(ui.define)
      .click(ui.define)
      .waitForElementVisible(ui.ui)
      .assert.elementPresent(ui.here)
  },
};
