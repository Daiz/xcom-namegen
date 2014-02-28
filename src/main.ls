enemy-within = (names) ->

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

  out
