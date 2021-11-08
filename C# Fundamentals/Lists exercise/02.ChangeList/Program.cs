using System;
using System.Collections.Generic;
using System.Linq;

namespace _02.ChangeList
{
    class Program
    {
        static void Main(string[] args)
        {
            List<int> numbers = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToList();

            string command = Console.ReadLine();

            while (command != "end")
            {
                string[] parts = command.Split();

                string currCommand = parts[0];
                int element = int.Parse(parts[1]);

                if (currCommand == "Delete")
                {
                    numbers.RemoveAll(x => x == element);
                }
                else
                {
                    int possition = int.Parse(parts[2]);
                    numbers.Insert(possition, element);
                }

                command = Console.ReadLine();
            }

            Console.WriteLine(string.Join(" ", numbers));
        }
    }
}
