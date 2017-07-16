var webpack = require("webpack");
var fs = require("fs");
var path = require("path");
var VERSION = JSON.stringify(process.env.BUILT_AT
  || process.env.HEROKU_SLUG_COMMIT
  || "NONE");
var WebpackNotifierPlugin = require("webpack-notifier");

var generateConfig = require("./webpack.config.base");
var exec = require("child_process").execSync;
var configPath = path.resolve(__dirname, "../src/config.json");
var FarmBotRenderer = require("./farmBotRenderer");

global.WEBPACK_ENV = "development";

c = function () {
  var conf = generateConfig();

  conf.output.filename = "dist/[name].js";

  conf
    .module
    .rules
    .push({
      test: [/\.scss$/, /\.css$/],
      use: ["style-loader", "css-loader", "sass-loader"]
    });

  conf
    .plugins
    .push(new webpack.DefinePlugin({
      "process.env.NODE_ENV": JSON.stringify("development")
    }));

  conf
    .plugins
    .push(new WebpackNotifierPlugin({
      title: "Webpack",
      excludeWarnings: false
    }));

  if (fs.existsSync(configPath)) {
    var config = require(configPath);
    conf.plugins.push(new webpack.DefinePlugin({
      "process.env.CONFIG": JSON.stringify(config)
    }));
  }

  return conf;
};

module.exports = c();
