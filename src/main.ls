Init = ->
  <-! $

  namelist = $ \textarea
  namecount = $ \#soldier-count
  names = []

  names-update = !->
    names-text = namelist.val!
    names := names-text
      .replace /\r\n|\r/g '\n'
      .replace /\n\n+/g '\n'
      .trim!
      .replace /"|;/g ''
      .split '\n'
    names := [] if !names-text


    namecount.text "#{names.length} names"

  names-update!

  namelist.on 'input propertychange change' names-update

  btn-ew  = $ \#eu-ew
  btn-lw  = $ \#long-war
  btn-b15 = $ \#lw-b15
  btn-og  = $ \#openxcom

  btn-ew.click ->
    namedata = Generator.enemy-within names
    Download.file namedata, "DefaultNameList.ini"

  btn-lw.click ->
    namedata = Generator.enemy-within names, true
    Download.file namedata, "DefaultNameList.ini"

  btn-b15.click ->
    namedata = Generator.long-war-b15 names
    Download.file namedata, "DefaultNameList.ini"

  btn-og.click ->
    namedata = Generator.openxcom names
    Download.file namedata, "SoldierName.zip"
