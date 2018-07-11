
module Main

import System

countDown : Int -> IO ()
countDown 0 = putStrLn "\n\n-- Timer Finished --"
countDown n = do putStrLn $ show n
                 secondDelay
                 countDown (n - 1)
              where secondDelay : IO ()
                    secondDelay = usleep 1000000

getCountdownNum : IO (Int)
getCountdownNum = do inp <- getLine
                     case inp of
                          "0" => putStrLn "Please input a number greater than zero." >>= \ _ => getCountdownNum
                          _ => case castToInt inp of
                                    0 => putStrLn "Please input a number." >>= \ _ => getCountdownNum
                                    i => pure i
                  where castToInt : (inp : String) -> Int
                        castToInt inp = cast inp

getCommandFromFile : IO (String)
getCommandFromFile = do Right cmd <- readFile "command.sh" | Left er => pure ""
                        pure cmd

main : IO ()
main = do
       cmd <- getCommandFromFile
       putStrLn "Welcome to your favorite cli countdown timer!"
       putStr "Enter how many seconds you want to set the timer for: "
       cdNum <- getCountdownNum
       putStrLn "---\n"
       countDown cdNum
       system cmd
       pure ()
