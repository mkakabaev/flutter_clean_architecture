const { h2 } = require("../../../.hygen");

// Add page_dir, page_type to the variables
module.exports = {
  params: ({ args, h }) =>
    h2.attach({
      h,
      args,
      featureRequired: false,
      postProcess: (result) => {
        let dto_path;
        if (result.feature) {
            dtos_dir = h.path.join(result.feature_dir, "data/dtos");
        } else {    
            if (result.service) {
                dtos_dir = h.path.join(result.service_dir, "dtos");
            } else  {
                throw new Error("Either --feature or --service is required");
            }
        }

        const { feature_dir, name_file, name_type } = result;
        const page_type = `${name_type}Page`;
        return {
          ...result,
          dtos_dir,
          dto_dir: dtos_dir,
        };
      },
    }),
};
