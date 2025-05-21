import 'package:flutter/material.dart';
import 'package:rumahku/utils/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;
          final isLast = index == totalSteps - 1;

          return Expanded(
            child: Row(
              children: [
                // Circle indicator
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                // Line connector
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}