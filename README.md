# Genetic

By mimicking the way life evolves, [genetic algorithms][1] move toward a
problem's best solution in a simple yet powerful way.

## How to Use It

Just define a data type to use as the gene and a function to evaluate how well
a gene solves your problem (this is called the fitness of that gene). Then
create a gene pool, let it evolve, and pick the winner.

Please look at `example.adb` for a simple example.


[1]: https://en.wikipedia.org/wiki/Genetic_algorithm