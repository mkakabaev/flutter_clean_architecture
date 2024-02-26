---
message: |

  ------   
  <%= h.bold("Create a new feature") %>
  hygen ca feature {name}                        

  <%= h.bold("Create a new entity") %>
  hygen ca entity {name} --feature {feature}                         

  <%= h.bold("Create a new repo") %>
  hygen ca repository {name} --feature {feature} [--entity {entity}]

  <%= h.bold("Create a new use case") %>
  hygen ca use_case {name} --feature {feature} --repo {repository}

  <%= h.bold("Create a new DTO object (JSON-backed)") %>
  hygen ca dto {name} --feature {feature}  // for a feature
  hygen ca dto {name} --service {service}  // for a service
  

  <%= h.bold("Create a new page") %>
  hygen ca page {name} --feature {feature}  

  ------   

  • to force overwrite files prepend a command with the  following environment variable:
  <%= h.bold("HYGEN_OVERWRITE=1") %> hygen ca {action} {name}  

  • to perform a dry run (files will be generated but not saved):
  hygen .... <%= h.bold("--dry") %> 

  • dump variables for debugging purposes:
  hygen .... <%= h.bold("--dump-vars") %> 

---