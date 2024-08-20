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
import 'package:todoo_list/objectbox.g.dart';
import 'package:todoo_list/view/task_form.dart';

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
            // You might want to handle state changes here if needed
          } else if (state is TaskErrorState) {
            print("Enter in the Error state: ${state.message}");
            // Handle error state here
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
                        "Today's Task",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: 5, // Adjust the number of placeholder items
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 15.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 20,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
