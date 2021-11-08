using System;
using System.Collections.Generic;

namespace _07.AppendArrays
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] line = Console.ReadLine().Split('|');

            List<string> numbers = new List<string>();

            for (int i = line.Length - 1; i >= 0; i--)
            {
                string[] splitet = line[i].Split(' ', StringSplitOptions.RemoveEmptyEntries);
                numbers.AddRange(splitet);
            }

            Console.WriteLine(string.Join(" ", numbers));
        }
    }
}
