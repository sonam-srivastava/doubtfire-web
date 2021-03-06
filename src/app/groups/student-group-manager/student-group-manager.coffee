angular.module('doubtfire.groups.student-group-manager', [])

#
# Context for students to see and manage groups
#
.directive('studentGroupManager', ->
  restrict: 'E'
  templateUrl: 'groups/student-group-manager/student-group-manager.tpl.html'
  replace: true
  controller: ($scope, Group, alertService, GroupMember, projectService) ->
    $scope.selectedGroup = null

    $scope.groupForSet = (gs) ->
      if gs
        _.find $scope.project.groups, (grp) -> grp.group_set_id == gs.id

    $scope.updateGroup = (data) ->
      Group.update(
        {
          unit_id: $scope.unit.id,
          group_set_id: $scope.selectedGroupset.id,
          id: $scope.selectedGroup.id,
          group: {
            name: data
          }
        }
        (response) -> alertService.add("success", "Group name changed", 2000)
        (response) -> alertService.add("danger", response.data.error, 6000)
      )

    $scope.onSelectGroup = (grp) ->
      GroupMember.create(
        {
          unit_id: $scope.unit.id,
          group_set_id:$scope.selectedGroupset.id,
          group_id: grp.id
          project_id: $scope.project.project_id
        },
        (response) ->
          projectService.updateGroups($scope.project) #change groups
          alertService.add("success", "Joined group", 2000)
          $scope.refreshGroupMembers()
        (error) ->
          alertService.add("danger", error.data.error, 6000)
          $scope.selectedGroup = null
      )

    $scope.$watch 'project', (newValue, oldValue) ->
      $scope.selectedGroup = $scope.groupForSet($scope.selectedGroupset)
      $scope.$digest #notify

    $scope.$watch 'selectedGroupset', (newValue, oldValue) ->
      $scope.selectedGroup = $scope.groupForSet(newValue)
      $scope.$digest #notify
)
