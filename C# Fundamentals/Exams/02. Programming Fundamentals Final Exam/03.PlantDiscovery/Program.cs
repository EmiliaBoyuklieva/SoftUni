using System;
using System.Linq;

using System.Collections.Generic;

namespace _03.PlantDiscovery
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            Dictionary <string,double> plantsRarity = new Dictionary<string, double>();
            Dictionary <string,List<double>> plantsRating = new Dictionary<string, List<double>>();
            
            for (int i = 0; i < n; i++)
            {
                string[] plant =Console.ReadLine().Split("<->");
                string name = plant[0];
                double rarity = double.Parse(plant[1]);
                plantsRarity.Add(name, rarity);
                plantsRating.Add(name, new List<double>());



            }

            string command = Console.ReadLine();

            while (command!= "Exhibition")
            {
                string[] parts = command.Split(": ");
                string operation = parts[0];
                string[] plantInfo = parts[1].Split(" - ");

                
                if(operation == "Rate")
                {
                    if (plantInfo.Length != 2)
                    {
                        Console.WriteLine("error");
                    }

                    string plantName = plantInfo[0];
                    double rating = double.Parse(plantInfo[1]);

                    if(plantsRating.ContainsKey(plantName))
                    {
                        plantsRating[plantName].Add(rating);
                    }
                    else
                    {
                        Console.WriteLine("error");
                    }

                }
                else if(operation== "Update")
                {
                    if (plantInfo.Length != 2)
                    {
                        Console.WriteLine("error");
                    }
                    string plantName = plantInfo[0];
                    int rarity= int.Parse(plantInfo[1]);

                    if (plantsRarity.ContainsKey(plantName))
                    {
                        plantsRarity[plantName] = rarity;
                    }
                    else
                    {
                        Console.WriteLine("error");
                    }
                   
                }
                else if(operation== "Reset")
                { 
                    if (plantInfo.Length != 1)
                    {
                        Console.WriteLine("error");
                    }
                
                    string plantName = plantInfo[0];

                    if (plantsRating.ContainsKey(plantName))
                    {
                        plantsRating[plantName].Clear();
                    }
                    else
                    {
                        Console.WriteLine("error");
                    }
                }
                else
                {
                    Console.WriteLine("error");
                }

                command = Console.ReadLine();
            }
            Dictionary<string, double> sorted = plantsRarity
               .OrderByDescending(x => x.Value)
               .ThenByDescending(x =>
               {
                   List<double> average = plantsRating[x.Key];

                   if (average.Count == 0)
                   {
                       return 0;
                   }
                   return average.Average();
               })
           .ToDictionary(x => x.Key, x => x.Value);

            Console.WriteLine("Plants for the exhibition:");

            foreach (var item in sorted)
            {
                double rating = 0;
                List<double> ratings = plantsRating[item.Key];
                if(ratings.Count != 0)
                {
                    rating = ratings.Average();
                }

                Console.WriteLine($" - {item.Key}; Rarity: {item.Value}; Rating: {rating:f2}");
            }
        }
    }
}
