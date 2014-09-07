'use strict'

angular.module 'persistantApp'
.constant 'TRICK_TYPES', {
  HOOK: 1

  getBaseDifferculty: (id) ->
    switch id
      when 1 then 5
}
