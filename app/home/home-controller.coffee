class HomeController
  constructor: (TriggerService, $cookies, $location) ->
    @location = $location
    @cookies = $cookies
    @TriggerService = TriggerService
    @colorIndex = 0

    return @location.path('/') unless @cookies.uuid
    return @location.path("/#{@cookies.uuid}/login") unless @cookies.token

    @TriggerService.getTriggers(@cookies.uuid, @cookies.token).then (@triggers) =>
      if @triggers.length < 1
        @showHelpMessage = true

      _.each @triggers, (trigger) =>
        trigger.color = "##{trigger.id[0...6]}"

    .catch (@error) =>
      @errorMsg = @error

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering

angular.module('blu').controller 'HomeController', HomeController
