/**
 * The main configuration file for Hygen (https://www.hygen.io/)
 *
 * cSpell: ignore hygen
 */

// Some trick. Define own helper and attach it to the Hygen context (h) as h.h2
class H2 {
  _required(key) {
    const n = this.h.changeCase.upper(key);
    const b = this.h.bold;
    throw new Error(
      `{${n}} is required. Add --${key} {value} command line argument`
    );
  }

  _getRequired(key) {
    const v = this.params[key];
    if (!v) {
      this._required(key);
    }
    return v;
  }

  file(key) {
    return this.h.changeCase.snake(this._getRequired(key));
  }

  type(key) {
    return this.h.changeCase.pascal(this._getRequired(key));
  }

  attach({ h, args, featureRequired = true, postProcess }) {
    h.h2 = this; // this way we can access it using h in templates
    this.h = h;

    const { name, feature, entity, dumpVars, service } = args;
    if (!name) {
      this._required("name");
    }
    if (!feature && featureRequired) {
      this._required("feature");
    }

    const lib_dir = h.path.normalize(h.path.join(__dirname, "lib"));

    const features_dir = h.path.join(lib_dir, "features");
    let feature_info = {};
    if (feature) {
      const file = h.changeCase.snake(feature);
      feature_info = {
        feature_file: file,
        feature_dir: h.path.join(features_dir, file),
        feature_name: h.changeCase.pascal(feature),
      };
    }

    const services_dir = h.path.join(lib_dir, "services");
    let service_info = {};
    if (service) {
      const file = h.changeCase.snake(service);
      service_info = {
        service_file: file,
        service_dir: h.path.join(services_dir, file),
        service_name: h.changeCase.pascal(service),
      };
    }

    const entity_info = {};
    if (entity) {
      entity_info.entity_file = h.changeCase.snake(entity);
      entity_info.entity_type = h.changeCase.pascal(entity);
    }

    const pascalCaseName = h.changeCase.pascal(name);
    const snakeCaseName = h.changeCase.snake(name);
    // const camelCaseName = h.changeCase.camel(name);
    // const names = h.inflection.pluralize(name);

    let result = {
      ...args,
      lib_dir,
      // features_dir,
      ...feature_info,
      ...service_info,
      ...entity_info,
      name_type: pascalCaseName,
      name_file: snakeCaseName,
    };
    this.params = result;

    // can patch/override in generators
    if (postProcess) {
      result = postProcess(result);
      this.params = result;
    }

    if (dumpVars) {
      console.log("Variables:", result);
    }

    return result;
  }
}

const h2 = new H2();

module.exports = {
  templates: `${__dirname}/.hygen`,
  helpers: {
    relative: (from, to) => path.relative(from, to),
    src: () => __dirname,
    lt: () => '<',
    bold: (str) => `\x1b[1m${str}\x1b[22m`,
  },
  h2,
  params: ({ args, h }) => h2.attach({ h, args }), // this is suitable for most cases
};
