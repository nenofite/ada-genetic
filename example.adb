with Genetic;

with Ada.Text_Io; use Ada.Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

with Ada.Numerics.Float_Random;

procedure Example is

   -- We need a random generator to produce and mutate genes. Here we'll use
   -- the built-in one.
   package Random renames Ada.Numerics.Float_Random;
   Rng : Random.Generator;

   -- The gene data type we will use. Usually genes are collections of floats,
   -- where each float is a parameter in the problem being solved.
   type Gene is record
      A, B : Float;
   end record;
   
   -- In our contrived example, the gene's fitness is just the sum of its two
   -- parts.
   function Fitness_Of (G : in Gene) return Float is
      (G.A + G.B);
      
   -- This function creates a random gene.
   function Random_Gene return Gene is
      -- Each part of the gene is given a random float value.
      ((A => Random.Random (Rng), B => Random.Random (Rng)));
      
   -- This procedure modifies a gene in a subtle way. Usually we'll just add or
   -- subtract a small random value from each part of the gene.
   procedure Mutate (G : in out Gene) is
   begin
      -- Add ±0.1 to each part of the gene.
      G.A := G.A + (Random.Random (Rng) * 0.2 - 0.1);
      G.B := G.B + (Random.Random (Rng) * 0.2 - 0.1);
   end Mutate;
      
   -- Now we'll create the `Genetic` package with data type and functions we've
   -- just defined.
   package Gen is new Genetic (
      -- These are all the data types and functions we defined above.
      Gene => Gene,
      Fitness_Of => Fitness_Of,
      Random_Gene => Random_Gene,
      Mutate => Mutate,
      -- How many genes to keep in the gene pool.
      Pool_Size => 100);
      
   -- This is just a helper function to show a gene in the output.
   procedure Put_Gene (G : in Gene) is
   begin
      -- Display the parts of the gene.
      Put ("A: ");
      Put (G.A);
      Put (", B: ");
      Put (G.B);
   end Put_Gene;
      
   -- This is the gene pool. It contains many genes competing to be the best
   -- and evolving over time.
   Pool : Gen.Pool;

begin

   -- Prepare the random number generator.
   Random.Reset (Rng);
   
   -- Fill the gene pool with random genes.
   Gen.Randomize (Pool);
   
   -- Repeat through many rounds of evolution.
   for N in 1 .. 10_000 loop
      Gen.Evolve (Pool);
   end loop;
   
   -- Now we've got a gene which will solve our problem fairly well.
   -- We'll show the gene.
   Put ("Best gene: ");
   Put_Gene (Gen.Best_Gene (Pool));
   New_Line;

end Example;