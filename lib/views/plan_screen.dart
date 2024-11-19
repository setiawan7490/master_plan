import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../providers/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;

  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: Column(
        children: [
          Expanded(child: _buildList(plansNotifier)),
          SafeArea(child: Text(plan.completenessMessage)),
        ],
      ),
      floatingActionButton: _buildAddTaskButton(plansNotifier),
    );
  }

  Widget _buildAddTaskButton(ValueNotifier<List<Plan>> plansNotifier) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        int planIndex =
            plansNotifier.value.indexWhere((p) => p.name == plan.name);
        plansNotifier.value = List<Plan>.from(plansNotifier.value)
          ..[planIndex] = Plan(
            name: plan.name,
            tasks: List<Task>.from(plan.tasks)..add(const Task()),
          );
      },
    );
  }

  Widget _buildList(ValueNotifier<List<Plan>> plansNotifier) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, plansNotifier),
    );
  }

  Widget _buildTaskTile(
      Task task, int index, ValueNotifier<List<Plan>> plansNotifier) {
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          int planIndex =
              plansNotifier.value.indexWhere((p) => p.name == plan.name);
          plansNotifier.value = List<Plan>.from(plansNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: List<Task>.from(plan.tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          int planIndex =
              plansNotifier.value.indexWhere((p) => p.name == plan.name);
          plansNotifier.value = List<Plan>.from(plansNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: List<Task>.from(plan.tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
        },
      ),
    );
  }
}
