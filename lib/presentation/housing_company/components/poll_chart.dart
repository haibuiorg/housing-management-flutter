import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/poll/entities/poll.dart';
import '../../../core/poll/entities/voting_option.dart';

class PollChart extends StatefulWidget {
  const PollChart({super.key, required this.poll});
  final Poll poll;

  @override
  State<PollChart> createState() => _PollChartState();
}

class _PollChartState extends State<PollChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (32 * (widget.poll.votingOptions.length.toDouble())),
      child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          // Initialize category axis
          primaryXAxis: CategoryAxis(
            maximumLabelWidth: 64,
            labelsExtent: 48,
            labelStyle: Theme.of(context).textTheme.labelSmall,
            labelAlignment: LabelAlignment.center,
            axisLine: const AxisLine(width: 0),
            placeLabelsNearAxisLine: true,
            majorTickLines: const MajorTickLines(size: 0),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
              desiredIntervals: 1),
          enableAxisAnimation: true,
          series: <CartesianSeries<VotingOption, String>>[
            BarSeries<VotingOption, String>(
                width: 1 / (widget.poll.votingOptions.length),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                // Bind data source
                animationDuration: 1500,
                color: Theme.of(context).colorScheme.primary,
                dataSource: (widget.poll.votingOptions),
                yValueMapper: (VotingOption votingOption, _) =>
                    votingOption.voters.length,
                xValueMapper: (VotingOption votingOption, _) =>
                    votingOption.description),
          ]),
    );
  }
}
