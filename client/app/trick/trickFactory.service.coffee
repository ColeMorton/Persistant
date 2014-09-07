'use strict'

angular.module 'persistantApp'
.factory 'trickFactory', (TRICK_TYPES) ->

  getCost: (tricker, trickId) ->
    differculty = TRICK_TYPES.getDifferculty(TRICK_TYPES.HOOK) / 20
    skill = tricker.hookSkill / 13
    cost = parseInt(differculty - skill)
    if cost < TRICK_TYPES.getMinCost TRICK_TYPES.HOOK
      cost = TRICK_TYPES.getMinCost TRICK_TYPES.HOOK
    cost

  getSkill: (tricker, trickId) ->
    switch trickId
      when TRICK_TYPES.HOOK then tricker.hookSkill

  getChance: (tricker, trickId, focus) ->
    console.log focus
    differculty = TRICK_TYPES.getDifferculty trickId
    skill = @getSkill tricker, trickId
    skill = skill / 2 if focus == 2

    result = parseInt(differculty / 4 + skill)
    result = 98 if result > 98
    result
