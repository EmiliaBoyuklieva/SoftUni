using System;
using System.Collections.Generic;
using System.Linq;

namespace _01.Train
{
    class Program
    {
        static void Main(string[] args)
        {
            List<int> wagon = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToList();

            int maxCapacity = int.Parse(Console.ReadLine());
            string command = Console.ReadLine();

            while (command != "end")
            {
                string[] parts = command.Split();

                if (parts[0] == "Add")
                {
                    int passengers = int.Parse(parts[1]);
                    wagon.Add(passengers);
                }
                else
                {
                    int passenger = int.Parse(parts[0]);

                    for (int i = 0; i < wagon.Count; i++)
                    {
                        int current = wagon[i];
                        if (passenger + current <= maxCapacity)
                        {
                            wagon[i] += passenger;
                            break;
                        }
                    }
                }

                command = Console.ReadLine();
            }

            Console.WriteLine(string.Join(" ", wagon));
        }
    }
}
