Generator =

  enemy-within: (names) ->
  
    countries = <[ Am Rs Ch In Af Mx Ab En Fr Gm Au It Jp Is Es Gr Nw Ir Sk Du Sc Bg Pl ]>
    doubled = /^(Rs|Pl)$/
  
    out = "[XComGame.XGCharacterGenerator]\n"
  
    for c in countries
      out += """
      m_arr#{c}MFirstNames=""
      m_arr#{c}FFirstNames=""

      """
  
    insert = (name, country) !->
      if doubled.test country
        out += """
        m_arr#{country}MLastNames=#{name}
        m_arr#{country}FLastNames=#{name}

        """
      else
       out += """m_arr#{country}LastNames=#{name}\n"""
  
    for name in names
      for country in countries
        insert name, country
  
    out.replace /\n/g '\r\n' # return contents of DefaultNameList.ini as string
  
  openxcom: (names, stable) ->
  
    countries =
      'American': [30 30 20 20]
      'Arabic': [0 1 99 0]
      'Belgium': [70 28 1 1]
      'British': [35 35 20 10]
      'Chinese': [1 1 93 5]
      'Congolese': [0 0 0 100]
      'Czech': [50 50 0 0]
      'Danish': [49 49 2 0]
      'Dutch': [45 45 5 5]
      'Ethiopian': [0 0 0 100]
      'Finnish': [49 49 1 1]
      'French': [43 42 2 13]
      'German': [44 44 9 3]
      'Greek': [50 49 1 0]
      'Hindi': [1 1 80 18]
      'Hungarian': [50 50 0 0]
      'Irish': [48 48 2 2]
      'Italian': [47 50 2 1]
      'Japanese': [2 3 94 1]
      'Kenyan': [0 0 1 99]
      'Korean': [0 0 100 0]
      'Nigerian': [0 0 0 100]
      'Norwegian': [50 43 7 0]
      'Polish': [50 50 0 0]
      'Polynesia': [0 2 49 49]
      'Portuguese': [2 88 2 8]
      'Romanian': [49 50 1 0]
      'Russian': [50 50 0 0]
      'Slovak': [45 55 0 0]
      'Spanish': [4 88 4 4]
      'Swedish': [60 40 0 0]
      'Turkish': [24 48 24 1]
  
    data = {}
  
    for country, look-weights of countries
  
      out = "lookWeights:\n"
      for weight in look-weights
        out += "  - #weight\n"
  
      out += "maleFirst:\n"
      for name in names
        out += "  - #name\n"
      
      out += "femaleFirst:\n"
      for name in names
        out += "  - #name\n"
      
      if stable
        out += 'maleLast:\n  - " "\nfemaleLast:\n  - " "\n' 

      out .= replace /\n/g '\r\n'
      data[country] = out
  
    zip = new JSZip!
    folder = zip.folder \SoldierName
    for country of countries
      folder.file "#country.nam" data[country]

    zip # return data as a jszip