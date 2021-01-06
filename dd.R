library(datasets)
data(iris)
mean(iris$Sepal.Length)
apply(iris[, 1:4], 2, mean)
data(mtcars)
mean(mtcars$mpg, mtcars$cyl)

r  <- tapply(mtcars$hp, mtcars$cyl, mean)


debug(ls)
tapply(mtcars$mpg, mtcars$cyl, mean)
sapply(split(mtcars$mpg, mtcars$cyl), mean)
with(mtcars, tapply(mpg, cyl, mean))
