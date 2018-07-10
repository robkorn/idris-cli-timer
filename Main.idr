
module Main

import System

countDown : Int -> IO ()
countDown 0 = putStrLn "\n\n-- Timer Finished --"
countDown n = do putStrLn $ show n
                 secondDelay
                 countDown (n - 1)
              where secondDelay : IO ()
                    secondDelay = usleep 1000000


main : IO ()
main = do
       putStrLn "Welcome to your favorite cli countdown timer!"
       countDown 10
