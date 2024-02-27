---
to: <%= page_dir %>/page.dart
---
import 'package:flutter/material.dart';
import 'package:mk_clean_architecture/core/core.dart';
import 'bloc.dart';

class <%= page_type %> extends StatefulWidget {
  const <%= page_type %>({
    super.key,
  });

  @override
  State createState() => _<%= page_type %>State();
}

class _<%= page_type %>State extends PageState<%- h.lt() %><%= page_type %>, <%= page_bloc_type %>, <%= page_bloc_state_type %>> {

  @override
  <%= page_bloc_type %> createBloc(PageController1 controller) => <%= page_bloc_type %>(controller);

  @override
  Widget buildPage(BuildContext context, <%= page_bloc_state_type %> blocState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('<%= page_type %>'),
      ),
      body: const Center(
        child: Text('<%= page_type %>'),
      ),
    );
  }
}
