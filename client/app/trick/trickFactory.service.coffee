'use strict'

angular.module 'persistantApp'
.factory 'trickFactory', (TRICK_TYPES, BELT_TYPES) ->

  getCost: (tricker, trickId) ->
    differculty = TRICK_TYPES.getDifferculty(trickId) / 20
    skill = tricker.skillHK / 13
    cost = parseInt(differculty - skill)
    if cost < TRICK_TYPES.getMinCost trickId
      cost = TRICK_TYPES.getMinCost trickId
    cost

  getChance: (tricker, trickId, focus) ->
    # console.log focus
    differculty = TRICK_TYPES.getDifferculty trickId
    skill = tricker["skill" + TRICK_TYPES.getCode(trickId)]
    skill += 25 if focus == 1

    result = parseInt(differculty / 8 + skill)
    result = 98 if result > 98
    result

  updateCost: (tricker, trickId) ->
    tricker["cost" + TRICK_TYPES.getName(trickId)] = @getCost tricker, trickId

  addTrickSuccessSkill: (tricker, trickId) ->
    tricker.skillHK += TRICK_TYPES.getTrickSuccessSkill trickId
    tricker.skillHK = 100 if tricker.skillHK > 100
    tricker.save()

  addTrickAttemptSkill: (tricker, trickId) ->
    tricker.skillHK += TRICK_TYPES.getTrickAttemptSkill trickId
    tricker.skillHK = 100 if tricker.skillHK > 100
    tricker.save()

  addTrickStyle: (tricker, trickId) ->
    tricker.styleHK += TRICK_TYPES.getTrickStyleSkill trickId
    tricker.save()

  updateBelt: (tricker, trickId) ->
    tricker.beltHK = tricker["skill" + TRICK_TYPES.getCode(trickId)] + tricker["style" + TRICK_TYPES.getCode(trickId)]
    tricker.beltColorHK = BELT_TYPES.getBeltNameBySkill tricker.beltHK
    tricker.save()
