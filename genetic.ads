generic

   -- Contains the genetic information which will be evolved. Often this is a
   -- record of floats, with each float determining a specific parameter to be
   -- optimized.
   type Gene is private;

   -- Determine the fitness of a gene. The greater the number returned, the
   -- better this gene is.
   with function Fitness_Of (G : in Gene) return Float;
   
   -- Randomly modify this gene in a subtle way. Successful genes will be
   -- mutated to explore whether subtle changes make genes which are more fit.
   with procedure Mutate (G : in out Gene);
   
   -- Create a new, completely random gene.
   with function Random_Gene return Gene;

   -- How many genes to keep in the pool.
   Pool_Size : Positive;

package Genetic is

   -- The collection of all genes currently being evolved, usually sorted from
   -- most to least fit.
   type Pool is private;

   -- Create a pool full of random genes. It will not be sorted yet.
   procedure Randomize (P : out Pool);
   
   -- Determine the sum of each gene's fitness within the gene pool.
   function Total_Fitness (P : in Pool) return Float;
   
   -- Advance the evolution of the genes. This first sorts the genes from most
   -- to least fit, then replaces the least fit genes with mutations of fit
   -- genes or random new genes.
   procedure Evolve (P : in out Pool);
   
   -- Get the most fit gene from the pool. The pool must be sorted before
   -- calling this.
   function Best_Gene (P : in Pool) return Gene;

private

   -- A gene along with cached fitness information.
   type Fit_Gene is record
      -- The gene.
      G : Gene;
      -- Whether the fitness of this gene has already been determined.
      Cached : Boolean;
      -- The cached fitness value. If `Cached` is false, ignore this value.
      Fitness : Float;
   end record;

   -- An index within a gene pool.
   subtype Pool_Index is Integer range 1 .. Pool_Size;
   
   -- The actual pool type.
   type Pool is array (Pool_Index) of Fit_Gene;

end Genetic;
