const { environment } = require("@rails/webpacker");

// Expose jQuery global variables.
// See:
//   https://is.gd/S3iA8R
//   https://is.gd/HZrGcK
environment.loaders.append("expose", {
  test: require.resolve("jquery"),
  use: [
    {
      loader: "expose-loader",
      options: "$"
    },
    {
      loader: "expose-loader",
      options: "jQuery"
    }
  ]
});

module.exports = environment;
