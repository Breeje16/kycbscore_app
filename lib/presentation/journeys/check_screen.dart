import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:traveller_ratings/presentation/blocs/check_customer/check_customer_cubit.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  TextEditingController searchController = TextEditingController();
  late List<CustomerRating> _chartData;
  late TooltipBehavior _tooltipBehavior;

  late CheckCustomerCubit checkCustomerCubit;

  @override
  void initState() {
    super.initState();
    checkCustomerCubit = BlocProvider.of<CheckCustomerCubit>(context);
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: const Icon(
                      Icons.search,
                      color: Colors.purple,
                    ),
                    margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      Map<String, dynamic> query = {"email": value};
                      checkCustomerCubit.getCustomerData(query);
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Customer using Email"),
                  ),
                )
              ],
            )),
        BlocConsumer<CheckCustomerCubit, CheckCustomerState>(
            buildWhen: (previous, current) => current is CheckCustomerError,
            builder: (context, state) {
              if (state is CheckCustomerError) {
                return const Text("Some Error");
              }
              return const SizedBox.shrink();
            },
            listenWhen: (previous, current) => current is CheckCustomerLoaded,
            listener: (context, state) {
              if (state is CheckCustomerLoaded) {
                Column(
                  children: [
                    Text(
                      "Results of " + state.customer.cEmail.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SfCircularChart(
                        title: ChartTitle(
                          text: "Customer Ratings Chart",
                          textStyle: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                        legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            backgroundColor: Colors.white),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries>[
                          RadialBarSeries<CustomerRating, String>(
                              dataSource: _chartData,
                              xValueMapper: (CustomerRating data, _) =>
                                  data.name,
                              yValueMapper: (CustomerRating data, _) =>
                                  data.value,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true)
                        ]),
                    Text(
                      "Net Score: " + state.customer.netScore.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
            }),
      ],
    );
  }

  List<CustomerRating> getChartData() {
    final List<CustomerRating> chartData = [
      CustomerRating("Positive", 35),
      CustomerRating("Neutral", 10),
      CustomerRating("Negative", 55),
    ];

    return chartData;
  }
}

class CustomerRating {
  final String name;
  final double value;
  CustomerRating(this.name, this.value);
}
