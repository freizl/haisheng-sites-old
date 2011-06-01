module Main where


> ----- Yet another Haskell toturial
> -- Exercise 3.10 Write a program that will repeatedly ask the user for numbers until she
> -- types in zero, at which point it will tell her the sum of all the numbers, the product of
> -- all the numbers, and, for each number, its factorial.

> main :: IO ()  
> main = do  
>     xs <- sgetline  
>     mapM_ (\s -> putStrLn s) ([showSum xs , showProduct xs] ++ (map showFactorial xs))  
>   where   
>     showSum x = "The sum is: " ++ (show . sum) x  
>     showProduct x = "The product is: " ++ (show . product) x  
>     showFactorial x = (show x) ++ " factorial is: " ++ (show . factorial) x  
>       
> sgetline :: IO [Int]  
> sgetline = do  
>     putStrLn "Give me a number (or 0 to stop) :"    
>     x <- getLine  
>     if x `elem` ["", "0"] then -- isStringEmpty??  
>       do return []  
>       else  
>       do xs <- sgetline  
>          return ((read x):xs)  
>   
> factorial n = product [1..n]
