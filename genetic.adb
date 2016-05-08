with Ada.Containers.Generic_Constrained_Array_Sort;

package body Genetic is

   -- Determine the sum of each gene's fitness within the gene pool.
   function Total_Fitness (P : in Pool) return Float is
      -- We will add up each gene's individual fitness.
      Result : Float := 0.0;
   begin
      -- For each gene in the pool
      for I in P'Range loop
         -- Add that gene's fitness.
         Result := Result + Fitness_Of (P (I).G);
      end loop;
      -- Return the sum.
      return Result;
   end Total_Fitness;

   -- Create a pool full of random genes. It will not be sorted yet.
   function Random_Pool return Pool is
      -- Create a full pool.
      Result : Full_Pool;
   begin
      -- For each gene in the pool
      for I in Result'Range loop
         -- Create a random gene.
         Result (I).G := Random_Gene;
         -- Since we have yet to evaluate the fitness of this gene, mark that
         -- it is not cached.
         Result (I).Cached := False;
      end loop;
      -- Return the pool we have created.
      return Result;
   end Random_Pool;

   -- Get the most fit gene from the pool. The pool must be sorted before
   -- calling this.
   function Best_Gene (P : in Pool) return Gene is
      -- Simply return the first element in the pool. Since the pool is
      -- required to be sorted before calling this function, the first element
      -- will be the most fit gene.
      (P (P'First).G);

   -- Compare the fitness of two genes. This function is used for sorting the
   -- gene pool.
   function Gene_Compare (Left, Right : in Fit_Gene) return Boolean is
      -- Simply compare the two genes' fitness.
      (Left.Fitness > Right.Fitness);

   -- Sort a gene pool by the fitness of each gene. We use Ada's built-in
   -- sorting procedure.
   procedure Pool_Sort is new Ada.Containers.Generic_Constrained_Array_Sort (
      Index_Type => Pool_Index,
      Element_Type => Fit_Gene,
      Array_Type => Full_Pool,
      "<" => Gene_Compare);

   -- Advance the evolution of the genes. This first sorts the genes from most
   -- to least fit, then replaces the least fit genes with mutations of fit
   -- genes or random new genes.
   procedure Evolve (P : in out Pool) is
      -- The last part of the pool, called the foreign space, gets replaced
      -- with new random genes. This is the first index of that part.
      Foreign_Space : Natural := P'Last - (P'Length / 10);
      -- The second half of the pool (not including the foreign space) gets
      -- replaced with mutations of the most fit genes. This is the first index
      -- of that part.
      Halfway : Natural := (P'First + Foreign_Space) / 2;
      -- The last index of the part of the pool being replaced by mutated
      -- genes. We will use this index when copying and mutating the most fit
      -- genes.
      Other_End : Natural := Foreign_Space - 1;
   begin
      -- First, we must get the fitness of each gene in the pool and sort.
      -- For each gene in the pool
      for I in P'Range loop
         -- Unless we already know the gene's fitness
         if not P (I).Cached then
            -- Calculate the gene's fitness.
            P (I).Fitness := Fitness_Of (P (I).G);
            -- Mark that we know this gene's fitness now.
            P (I).Cached := True;
         end if;
      end loop;
      -- Sort the gene pool so the most fit genes are at the front.
      Pool_Sort (P);
      -- Next, we will mutate the most fit genes.
      -- For each of the most fit genes
      for I in P'First .. Halfway loop
         -- Copy the gene over into the second half. `Other_End` is the index
         -- into which we copy the gene.
         P (Other_End) := P (I);
         -- Mutate the gene.
         Mutate (P (Other_End).G);
         -- Because we have changed the gene, its fitness will change too. Mark
         -- that we no longer know its fitness.
         P (Other_End).Cached := False;
         -- Move the other end index to the next position.
         Other_End := Other_End - 1;
      end loop;
      -- Finally, we will introduce some new random genes at the end of the
      -- pool.
      -- For each gene in the foreign space
      for I in Foreign_Space .. P'Last loop
         -- Replace the gene with a random new one.
         P (I).G := Random_Gene;
         -- Since this is a completely new gene, we don't know its fitness yet.
         P (I).Cached := False;
      end loop;
   end Evolve;

end Genetic;
