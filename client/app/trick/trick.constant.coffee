'use strict'

angular.module 'persistantApp'
.constant 'TRICK_TYPES', {
  HOOK: 1

  getName: (id) ->
    switch id
      when 1 then "Hook"

  getCode: (id) ->
    switch id
      when 1 then "HK"

  getDifferculty: (id) ->
    switch id
      when 1 then 200

  getMinCost: (id) ->
    switch id
      when 1 then 2

  getTrickSuccessSkill: (id) ->
    switch id
      when 1 then 7

  getTrickAttemptSkill: (id) ->
    switch id
      when 1 then 3

  getTrickStyleSkill: (id) ->
    switch id
      when 1 then 2

}

'use strict'

angular.module 'persistantApp'
.constant 'BELT_TYPES', {
  WHITE: 1
  GREEN: 2
  YELLOW: 3
  BLUE: 4
  RED: 5
  BROWN: 6
  BLACK: 7
  FIRST_DAN: 8
  SECOND_DAN: 9
  THIRD_DAN: 10

  getName: (id) ->
    switch id
      when 1 then "WHITE"
      when 2 then "GREEN"
      when 3 then "YELLOW"
      when 4 then "BLUE"
      when 5 then "RED"
      when 6 then "BROWN"
      when 7 then "BLACK"

  getBeltBySkill: (skill) ->
    belt = switch
      when skill < 30 then 1
      when skill >= 30 && skill < 60 then 2
      when skill >= 60 && skill < 90 then 3
      when skill >= 90 && skill < 120 then 4
      when skill >= 120 && skill < 150 then 5
      when skill >= 150 && skill < 180 then 6
      when skill >= 180 && skill < 210 then 7
      when skill >= 210 && skill < 240 then 8

  getBeltNameBySkill: (skill) ->
    @getName @getBeltBySkill(skill)

}
