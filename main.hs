import Control.Monad

import Text.Regex.TDFA
import Text.Regex.TDFA.Text ()

import Data.List.Split
import Control.Exception

import Relude.List

data MyException = InvalidUserInput deriving Show
instance Exception MyException

data Peer = Peer {
		ip   :: String,
		port :: String
	} deriving Show

data Node = Node {
		messagesSent :: [(String, Bool)],
		peers        :: [Peer]
	} deriving Show

connectTo peer = do print "Can not connect as the function is not yet implemented"

startNetwork = do print "Can not start network as the function is not yet implemented"

-- Todo: Make sure that the ip is valid
parseUserInput :: String -> Either Peer MyException
parseUserInput userInput =
	let
		splitUserInput = splitOn ":" userInput
	in
		if not $ length splitUserInput == 2 then
			Right InvalidUserInput
		else
			Left $ Peer (splitUserInput !! 0) (splitUserInput !! 1)

main :: IO()
main = do
	putStrLn "Please input an ip and a port in the form \"ip:port\""

	userInput <- getLine
	case parseUserInput userInput of
		Right _ -> startNetwork
		Left peer -> connectTo peer
