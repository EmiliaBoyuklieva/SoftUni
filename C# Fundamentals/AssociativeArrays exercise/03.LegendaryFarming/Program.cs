using System;
using System.Collections.Generic;
using System.Linq;

namespace _03.LegendaryFarming
{
    class Program
    {
        static void Main(string[] args)
        {
            Dictionary<string, int> legendary = new Dictionary<string, int>
            {
                  { "shards",0  },
                  { "fragments",0},
                  { "motes",0},
            };

            SortedDictionary<string, int> junk = new SortedDictionary<string, int>();

            string winnerItem = string.Empty;
            bool isRunning = true;

            while (isRunning)
            {
                string[] parts = Console.ReadLine().Split();

                for (int i = 0; i < parts.Length; i += 2)
                {
                    int quantity = int.Parse(parts[i]);

                    string item = parts[i + 1].ToLower();

                    if (legendary.ContainsKey(item))
                    {
                        legendary[item] += quantity;

                        if (legendary[item] >= 250)
                        {
                            winnerItem = item;
                            legendary[item] -= 250;
                            isRunning = false;
                            break;
                        }
                    }
                    else
                    {
                        if (junk.ContainsKey(item))
                        {
                            junk[item] += quantity;
                        }
                        else
                        {
                            junk.Add(item, quantity);
                        }
                    }
                }
            }

            if (winnerItem == "shards")
            {
                Console.WriteLine("Shadowmourne obtained!");
            }
            else if (winnerItem == "fragments")
            {
                Console.WriteLine("Valanyr obtained!");
            }
            else if (winnerItem == "motes")
            {
                Console.WriteLine("Dragonwrath obtained!");
            }

            Dictionary<string, int> sortedLegendary = legendary
                .OrderByDescending(i => i.Value)
                .ThenBy(i => i.Key)
                .ToDictionary(x => x.Key, x => x.Value);

            foreach (var item in sortedLegendary)
            {
                Console.WriteLine($"{item.Key}: {item.Value}");
            }
            foreach (var item in junk)
            {
                Console.WriteLine($"{item.Key}: {item.Value}");
            }

        }
    }
}
