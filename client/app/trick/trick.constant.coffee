'use strict'

angular.module 'persistantApp'
.constant 'TRICK_TYPES', {
  HOOK: 1

  getName: (id) ->
    switch id
      when 1 then "Hook"

  getDifferculty: (id) ->
    switch id
      when 1 then 200

  getMinCost: (id) ->
    switch id
      when 1 then 2

  getTrickSuccessSkill: (id) ->
    switch id
      when 1 then 10
}
