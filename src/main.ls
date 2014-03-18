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
      .split '\n'
    names := [] if !names-text

    namecount.text "#{names.length} names"

  names-update!

  namelist.on 'input propertychange change' names-update

  btn-ew = $ \#eu-ew
  btn-xn = $ \#xenos
  btn-og = $ \#og-nightly
  btn-os = $ \#og-stable

  btn-ew.click ->
    namedata = Generator.enemy-within names
    Download.file namedata, "DefaultNameList.ini"

  btn-og.click ->
    namedata = Generator.openxcom names
    Download.file namedata, "SoldierName.zip"

  btn-os.click ->
    namedata = Generator.openxcom names, true
    Download.file namedata, "SoldierName.zip"