module FixtureReplacement
  
  attributes_for :centre do |c|
    c.denomination = String.random(15)
    c.generic_denomination = String.random(10)
    c.url = "http://test.com/#{c.denomination.gsub(' ', '-')}"
    
    c.country = "España"
    c.region = String.random(10)
    c.province = String.random(10)
    c.town = String.random(8)
    c.locality = String.random(8)
    c.county = String.random(8)
    c.address = String.random(10)
    c.postal_code = "460#{random(1+20)}"
    
    c.ownership = ["Centro público", "Centro privado", "Centro concertado"].pick
    c.centre_type = String.random(10)
  end
  
  attributes_for :teaching do |t|
    t.level = "Ciclo Formativo de Grado Medio"
    t.area = "Química"
    t.teaching = "Laboratorio"
  end
  
end