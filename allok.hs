{-# LANGUAGE OverloadedStrings #-}
import Data.Ini
import Control.Monad
import Network.HTTP.Client
import Network.HTTP.Types.Status (statusCode)
import qualified Data.Aeson as A
import qualified Data.Text as T

basicCheckSection         = "basic_check"
recibosWebApiCheckSection = "recibos_web_api_check"

fromR (Right x) = x

basicCheck (k,v) = do
    manager <- newManager defaultManagerSettings
    request <- parseRequest (T.unpack v)
    response <- httpLbs request manager
    return $ (k,statusCode $ responseStatus response)

recibosWebApiCheck (k,v) = do
    manager <- newManager defaultManagerSettings
    request <- parseRequest (T.unpack v)
    let requestObject = object ["NombreMunicipio" .= v]
    let request' = request { method = "POST", requestBody = RequestBodyLBS $ A.encode requestObject }
    response <- httpLbs request manager
    return $ (k,statusCode $ responseStatus response)

myLookup f sec = zip (keys_) (fmap (\k -> fromR $ lookupValue sec k f) keys_) 
    where keys_ = fromR $ keys sec f

main = do
    Right config <- readIniFile "config.ini"  
    let [basicCheckPairs, recibosWebApiCheckPairs] 
            = (myLookup config) <$> [ basicCheckSection
                                    , recibosWebApiCheckSection ]
    basicCheckR <- mapM basicCheck basicCheckPairs 
    print $ basicCheckR 
    print $ recibosWebApiCheck <$> recibosWebApiCheckPairs
    return ()