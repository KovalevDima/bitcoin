{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Network.HTTP.Simple           (httpBS, getResponseBody)   
import           Control.Lens                  ( preview )
import           Data.Aeson.Lens               ( key, _String )            
import qualified Data.ByteString.Char8         as BS
import           Data.Text                     ( Text )
import qualified Data.Text.IO                  as TIO


fetchJSON :: IO BS.ByteString
fetchJSON = do
  res <- httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
  return (getResponseBody res)


getRateIn :: Text -> BS.ByteString -> Maybe Text
getRateIn currency = preview (key "bpi" . key currency . key "rate" . _String)


main :: IO ()
main = do
  json <- fetchJSON
  BS.putStrLn "The current Bitcoin rate:"

  case getRateIn "USD" json of
    Nothing   -> TIO.putStrLn "   Could not find the Bitcoin rate in USD :("
    Just rate -> TIO.putStrLn $ "   " <> rate <> " USD"

  case getRateIn "GBP" json of
    Nothing   -> TIO.putStrLn "   Could not find the Bitcoin rate in GBP :("
    Just rate -> TIO.putStrLn $ "   " <> rate <> " GBP"
  
  case getRateIn "EUR" json of
    Nothing   -> TIO.putStrLn "   Could not find the Bitcoin rate in EUR :("
    Just rate -> TIO.putStrLn $ "   " <> rate <> " EUR"

  