const { h2 } = require("../../../.hygen");

module.exports = {
  // for consistency we will put {name} as {feature}
  params: ({ args, h }) =>
    h2.attach({ h, args: { ...args, feature: args.name } }),
};
