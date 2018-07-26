
module Main

import System

countDown : Int -> IO ()
countDown 0 = putStrLn "\n\n-- Timer Finished --"
countDown n = do putStrLn $ show n
                 secondDelay
                 countDown (n - 1)
              where secondDelay : IO ()
                    secondDelay = usleep 1000000

getCountdownNumIO : IO (Int)
getCountdownNumIO = do putStr "Enter how many seconds you want to set the timer for: "
                       inp <- getLine
                       case inp of
                             "0" => putStrLn "Please input a number greater than zero." >>= \ _ => getCountdownNumIO
                             _ => case (the Int (cast inp)) of
                                       0 => putStrLn "Please input a number." >>= \ _ => getCountdownNumIO
                                       i => pure i

getCountdownNum : (args : List (String)) -> IO Int
getCountdownNum args = case Prelude.List.index' 1 args of
                            Nothing => getCountdownNumIO
                            Just n => if cast n == 0 then getCountdownNumIO else pure $ cast n

getCommandFromFile : IO (String)
getCommandFromFile = do Right cmd <- readFile "command.sh" | Left er => pure ""
                        pure cmd

main : IO ()
main = do
       args <- getArgs
       putStrLn "Welcome to your favorite cli countdown timer!"
       cdNum <- getCountdownNum args
       putStrLn "---\n"
       countDown cdNum
       cmd <- getCommandFromFile
       system cmd
       pure ()
