# Selenium Falcon -- Acceptance Tester

### What:

Selenium Falcon is a shell / starting point to easily create an acceptance test suite for your website.
Selenium Falcon uses [Nightwatch](https://github.com/beatfactor/nightwatch), which in turn uses [Selenium](https://code.google.com/p/selenium/wiki/WebDriverJs).

### Install:

Ensure java is installed:
* [Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get) (`apt-get install default-jre default-jdk`)
* [Mac](http://hanxue-it.blogspot.com/2014/05/installing-java-8-managing-multiple.html) (`brew update && brew cask install java`)

```sh
npm install
```

### Run:

##### Local:

Running locally means using a browser on your machine. You will see a browser window appear when you run this command.

```sh
npm start
```

##### Remote:

Running remotely means using an external service to launch the browser. A good example is [Browserstack](https://www.browserstack.com/), so I've included
that, and examples for that, in the example repo.

First [create a config file](#config:). Then:

```sh
npm run-script remote
```

##### Running with a single tag:

Each test can be given an arbitrary number of tags. These help to group tests. To run with a single tag, say, "tag1":

```sh
npm start -- --tag tag1
```

##### Running without a tag:

We can also omit a certain tag and run all tests that don't hit that product:

```sh
npm start -- --skiptags tag1
```

For more goodies, including running in parallel and using groups, please read the excellent [docs](http://nightwatchjs.org/guide).

### Clean:

```sh
npm run-script clean
```

### Config:

```sh
mkdir -p ~/.selenium_falcon
cp ./nightwatch_remote.default.json ~/.selenium_falcon/default.json
```

You'll need a config file to run tests remotely on browserstack, the default for this repo. Of course, also feel free to use your own remote
solution, if you want one at all :) If you do stick with browserstack, get your username and an access key by signing into
[browserstack](https://www.browserstack.com/automate) and clicking "Username and Access Keys" on the top left.

Add your username and access key into the appropriate place:

```sh
sed -ie 's/<your bs Username>/$YOUR_BROWSERSTACK_USERNAME/' ~/.selenium_falcon/default.json && cat ~/.selenium_falcon/default.json
sed -ie 's/<your bs Access Key>/$YOUR_BROWSERSTACK_ACCESS_KEY/' ~/.selenium_falcon/default.json && cat ~/.selenium_falcon/default.json
```

### Notes:
* Visit https://www.browserstack.com/automate to see some visual history of your tests
* If you use tmux you'll need to do this http://borkweb.com/story/chromedriver-doesnt-run-in-tmux
