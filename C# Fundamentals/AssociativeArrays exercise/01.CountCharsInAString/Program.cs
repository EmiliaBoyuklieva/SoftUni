using System;
using System.Collections.Generic;

namespace _01.CountCharsInAString
{
    class Program
    {
        static void Main(string[] args)
        {
            Dictionary<char, int> counts = new Dictionary<char, int>();

            string word = Console.ReadLine();

            foreach (var symbol in word)
            {
                if (symbol == ' ')
                {
                    continue;
                }
                else
                {
                    if (counts.ContainsKey(symbol))
                    {
                        counts[symbol]++;
                    }
                    else
                    {
                        counts.Add(symbol, 1);
                    }
                }

            }
            foreach (var item in counts)
            {
                Console.WriteLine($"{item.Key} -> {item.Value}");
            }
        }
    }
}
