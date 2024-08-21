import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoo_list/bloc/main_bloc.dart';
import 'package:todoo_list/bloc/main_event.dart';
import 'package:todoo_list/bloc/main_state.dart';
import 'package:todoo_list/constant/widgetConstant.dart';
import 'package:todoo_list/helper/object_box.dart';
import 'package:todoo_list/model/taskData.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI>
    with SingleTickerProviderStateMixin {
  late MainBloc _mainBloc;
  late ObjectBox objectBox;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool loadingstatus = true;

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mainBloc.add(GetAllTaskEvent());

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChanged);

    loadingstatus = true;
  }

  void _handleTabChanged() {
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  List<TaskData> get filteredTasks {
    switch (_selectedTabIndex) {
      case 0: // All
        return _mainBloc.state is TaskLoadedState
            ? (_mainBloc.state as TaskLoadedState).tasks
            : [];
      case 1: // Open
        return (_mainBloc.state is TaskLoadedState)
            ? (_mainBloc.state as TaskLoadedState)
                .tasks
                .where((task) => !task.completed!)
                .toList()
            : [];
      case 2: // Closed
        return (_mainBloc.state is TaskLoadedState)
            ? (_mainBloc.state as TaskLoadedState)
                .tasks
                .where((task) => task.completed!)
                .toList()
            : [];
      default:
        return [];
    }
  }

  List<TaskData> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<MainBloc, MainState>(
        listener: (BuildContext context, state) {
          if (state is TaskLoadingState) {
            setState(() {
              loadingstatus = true;
            });
          } else if (state is TaskLoadedState) {
            tasks.clear();
            tasks.addAll(state.tasks);
            setState(() {
              loadingstatus = false;
            });
          } else if (state is TaskErrorState) {
            print("Enter in the Error state: ${state.message}");
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                      child: Text(
                        "Today's\n Task",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(
                          top: 45.0, right: 20.0, left: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddTaskDialog(context, _mainBloc);
                        },
                        icon:
                            Icon(Icons.add, color: Theme.of(context).hintColor),
                        label: Text(
                          "New Task",
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            backgroundColor: Theme.of(context).highlightColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35.0,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Open"),
                  Tab(text: "Closed"),
                ],
                indicatorColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).hintColor,
                unselectedLabelColor: Colors.grey[500],
              ),
              loadingstatus
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: BlocBuilder<MainBloc, MainState>(
                          builder: (context, state) {
                        return ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = filteredTasks[index];

                            return taskCard(task, _mainBloc);
                          },
                        );
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
