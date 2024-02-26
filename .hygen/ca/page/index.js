const { h2 } = require("../../../.hygen");

// Add page_dir, page_type to the variables
module.exports = {
  params: ({ args, h }) =>
    h2.attach({
      h,
      args,
      postProcess: (result) => {
        const { feature_dir, name_file, name_type } = result;
        const page_type = `${name_type}Page`;
        return {
          ...result,
          page_dir: h.path.join(
            feature_dir,
            "presentation",
            "pages",
            name_file
          ),
          page_type,
          page_bloc_type: `${page_type}Bloc`,
          page_bloc_state_type: `${page_type}BlocState`,
        };
      },
    }),
};
