class HomeController
  constructor: ($cookies, $location, DeviceService, TriggerService) ->
    @cookies = $cookies
    @cookies.uuid = 'e9f43a10-bc75-11e4-a7c8-ff1cd8e84559'
    @cookies.token = '2248a80db251c8a7e673e7086b3835d95939907a'
    @location = $location
    @DeviceService = DeviceService
    @TriggerService = TriggerService
    @colorIndex = 0
    @randomRobotId = _.sample [1...9]

    devicePromise = @DeviceService.getDevice(@cookies.uuid, @cookies.token)
    devicePromise.catch @redirectToLogin
    devicePromise.then (@device) =>
      @triggersLoaded = true
      return @notClaimed = true unless @device.owner?

      @refreshTriggers().catch (error) =>
        @errorMessage = error.message

  refreshTriggers: =>
    @TriggerService.getTriggers(@cookies.uuid, @cookies.token, @device.owner).then (@triggers) =>
      @noFlows = _.isEmpty @triggers

      _.each @triggers, (trigger, i) =>
        trigger.color = "##{trigger.id[0...6]}"
        trigger.span  = if i % 5 == 0 then 2 else 1

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering


angular.module('blu').controller 'HomeController', HomeController
