require 'inifile'
require 'httparty'
require 'json'

puts "basic check:"
IniFile.load('./config.ini')['basic_check'].each do |pair| 
    begin
        case HTTParty.get(pair[1]).code    
            when 200 ; puts "✔   #{pair[0]}" 
            else     ; puts "✘   #{pair[0]}"
        end   
    rescue
        puts "✘✘  #{pair[0]}"
    end
end 

puts "recibos web api check:"
IniFile.load('./config.ini')['recibos_web_api_check'].each do |pair| 
    begin      
        r = HTTParty.post("http://45.77.164.42:8088/municipio" ,
        :body => {"CodigoMunicipio" => pair[1]}.to_json ) 
        resP = JSON.parse(r.body)
        case (resP["Exito"] && (resP["Nombre"] != ""))
            when true  ; puts "✔   #{pair[0]}"    
            else       ; puts "✘   #{pair[0]}"
        end
    rescue
        puts "✘✘  #{pair[0]}"
    end                
end

puts "Done!" 
puts "press enter to exit"
gets 
