angular.module('doubtfire.tasks.task-status-selector',[])

.directive('taskStatusSelector', ->
  replace: true
  restrict: 'E'
  templateUrl: 'tasks/task-status-selector/task-status-selector.tpl.html'
  scope:
    task: "=task"
    assessingUnitRole: "=assessingUnitRole"
    inMenu: "=inMenu"
    triggerTransition: "=triggerTransition"
  controller: ($scope, taskService) ->
    #
    # Statuses tutors/students may change task to
    #
    $scope.studentStatuses  = taskService.switchableStates.student
    $scope.tutorStatuses    = taskService.switchableStates.tutor
    $scope.taskEngagementConfig = {
      studentTriggers: $scope.studentStatuses.map (status) ->
        { status: status, label: taskService.statusLabels[status], iconClass: taskService.statusIcons[status], taskClass: _.trim(_.dasherize(status), '-'), helpText: taskService.helpText(status) }
      tutorTriggers: $scope.tutorStatuses.map (status) ->
        { status: status, label: taskService.statusLabels[status], iconClass: taskService.statusIcons[status], taskClass: _.trim(_.dasherize(status), '-'), helpText: taskService.helpText(status) }
      }
)
