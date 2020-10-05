require 'inifile'
require 'httparty'

if ARGV.length == 0
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
    puts "Done!" 
    puts "press enter to exit"
    gets 
else
    puts "for now we dont support arguments"
end