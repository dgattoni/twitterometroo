require 'twitter'

#class Author: Daniela Gattoni (2015) 
#twitter: @danigattoni_
#danielagattoni.quiltyweb.com


class Twitterometer

     #variable de clase 
     @@quantityOfInstances = 0
     @geocode = false
     @recentUntil = false

     #constructor
     def initialize twitterCredentials

      @@quantityOfInstances = @@quantityOfInstances +1

      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = twitterCredentials[0]
        config.consumer_secret     = twitterCredentials[1]
        config.access_token        = twitterCredentials[2]
        config.access_token_secret = twitterCredentials[3]
      end
    end

    #metodo que filtra tweets en base a 4 argumentos: palabra clave, eliminarRt,  limite de fecha, cantidad max. de tweets 
    def filterRecentUntil keyword, eliminarRt, untilDate, maxNumberOfTweets
       @keyword      = keyword      
       @eliminarRt   = eliminarRt      
       @geocode      = false
       @recentUntil  = true
       arr_users     =[]      
       
       @untilDate = untilDate
       maxNumberOfTweets = maxNumberOfTweets
   
      rt = "-RT".to_s unless @eliminarRt == false

       @client.search("#{@keyword} ".to_s + rt.to_s, result_type: "recent",  until: @untilDate).take(maxNumberOfTweets).collect do |tweet|   
         puts " #{tweet.created_at}  => #{tweet.user.screen_name} : #{tweet.text} "       
         arr_users.push(tweet.user.screen_name)    
       end
       return arr_users
   end

    #metodo para buscar por palabra clave, latitud, lingitud, kms a la redonda, y maximo de tweets a buscar.
    def filterGeoCode keyword, eliminarRt, latitude, longitude, radiusNumber, maxNumberOfTweets
        @geocode = true
        @recentUntil = false
        arr_users= []      
        @keyword  = keyword
        latitude = latitude
        longitude = longitude
        radiusNumber = radiusNumber
        maxNumberOfTweets = maxNumberOfTweets

        @client.search("#{keyword} -RT",result_type: "recent", geocode: " #{latitude},#{longitude},#{radiusNumber}km").take(maxNumberOfTweets).collect do |tweet|   
         puts " #{tweet.created_at}  => #{tweet.user.screen_name} : #{tweet.text} "
         arr_users.push(tweet.user.screen_name)    
        end
        return arr_users
    end


     # metodo para crear un hash en base a un array de twitteros por cada twittero encontrado agrega +1 a su key correspondiente.
     def createHashfrom array
      counts = Hash.new 0
      array.each do |user|
       counts[user] += 1
     end
     return counts
    end


    #metodo que ordena un hash en base al value y lo muestra por pantalla con formato name -> valor
    def display unHash
      puts ""
      print "¿Quien ha twitteado más sobre #{@keyword} " 
      print "hasta la fecha: #{@untilDate}" unless @recentUntil == false
      puts ""
      unHash.sort_by { |name, freq| freq }.reverse.each {|name, freq| puts name.to_s + "-> "+freq.to_s + " tweet"  }
    end     

    #metodo de clase para contar cuantos twitterometros se han instanciado.
    def self.count
      puts ""
      puts ""
      puts " hay " + @@quantityOfInstances.to_s + " twitterometros instanciados."
    end

end

#dataAccess = ["your_consumer_secret","your_consumer_secret","your_access_token", "your_access_token_secret"]
dataAccess = ["...","...","...", "..."]

#instancio un nuevo twitterometro. con keys de acceso creadas en https://apps.twitter.com/
desafioTwitteros = Twitterometer.new dataAccess  

# otro tipo de filtro aqui es .filterGeoCode keyword, eliminarRt, latitude, longitude, radiusNumber, maxNumberOfTweets

myArray = desafioTwitteros.filterRecentUntil "DesafioLatam", true, "2015-03-01", 50

myHash = desafioTwitteros.createHashfrom myArray

desafioTwitteros.display myHash


#cantidad de twitterometros instanciados:
Twitterometer.count
