import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/polls/poll_creation_form.dart';
import 'package:priorli/presentation/polls/poll_detail.dart';
import 'package:priorli/presentation/polls/poll_screen_cubit.dart';
import 'package:priorli/presentation/polls/poll_screen_state.dart';
import 'package:priorli/service_locator.dart';

import '../shared/app_lottie_animation.dart';

const pollScreenPath = 'polls';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key, this.pollId, required this.companyId});
  final String? pollId;
  final String companyId;

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  late final PollScreenCubit _cubit;
  @override
  void initState() {
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
    super.initState();
  }

  _getInitialData() async {
    if (widget.pollId != null && widget.pollId?.isNotEmpty == true) {
      await _cubit.init(pollId: widget.pollId, companyId: widget.companyId);
      return;
    }
    await _cubit.init(pollId: null, companyId: widget.companyId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _cubit,
        child: BlocConsumer<PollScreenCubit, PollScreenState>(
            listener: (context, state) {},
            builder: (context, state) {
              return state.isInitializing
                  ? Scaffold(
                      appBar: AppBar(
                        title: const Text('Poll loading'),
                      ),
                      body: const AppLottieAnimation(
                        loadingResource: 'vote',
                      ),
                    )
                  : state.poll != null
                      ? PollDetail(
                          userId: state.userId ?? '',
                          companyId: state.companyId ?? '',
                          poll: state.poll!,
                          onAddMoreVotingOptions: _cubit.addPollOption,
                          onDelete: _cubit.deletePoll,
                          onRemoveVotingOption: _cubit.removePollOption,
                          onSelectVotingOption: _cubit.selectPollOption,
                          onSubmit: _cubit.editPoll,
                        )
                      : PollCreationForm(
                          companyId: state.companyId ?? '',
                          onSubmit: _cubit.createPoll);
            }));
  }
}
