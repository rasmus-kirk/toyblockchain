import Control.Monad
import Control.Concurrent
--import Text.Regex.TDFA

import Text.Regex.TDFA.Text ()

import Data.List.Split
import Control.Exception

import Network.Socket

import System.IO
import System.Random

nodePort = 7777

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

connectTo :: Peer -> IO()
connectTo peer = do print peer --"Can not connect as the function is not yet implemented"

startNetwork :: IO()
startNetwork = do
	sock <- socket AF_INET Stream 0    -- create socket

	bind sock (SockAddrInet nodePort 0)    -- listen on TCP port 4000.
	setSocketOption sock ReuseAddr 1   -- make socket immediately reusable - eases debugging.
	listen sock 2                      -- set a max of 2 queued connections

	putStrLn $ "Listening on port " ++ show nodePort ++ "..."
	forever $ do
		(conn, _) <- accept sock
		forkIO(runConn conn)
		--runConn conn
		return ()

runConn :: Socket ->  IO()
runConn conn = do
	putStrLn "New connection accepted"
	handleSock <- socketToHandle conn ReadWriteMode

	loop handleSock
	where loop handleSock = do
		line <- hGetLine handleSock
		putStrLn $ "Request received: " ++ line

		if line == "exit" then
			gracefulClose conn 5000
		else do
			hPutStrLn handleSock $ "Hey, client! You typed: " ++ line
			loop handleSock

-- Todo: Make sure that the ip is valid, use regex
parseUserInput :: String -> Either Peer MyException
parseUserInput userInput =
	let
		splitUserInput = splitOn ":" userInput
	in
		if length splitUserInput /= 2 then
			Right InvalidUserInput
		else
			Left $ Peer (head splitUserInput) (last splitUserInput)

main :: IO()
main = do
	putStrLn "Please input an ip and a port in the form \"ip:port\""

	userInput <- getLine
	case parseUserInput userInput of
		Right _ -> startNetwork
		Left peer -> connectTo peer