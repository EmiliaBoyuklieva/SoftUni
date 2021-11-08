using System;
using System.Collections.Generic;

namespace _03.HouseParty
{
    class Program
    {
        static void Main(string[] args)
        {
            int numberOfCommands = int.Parse(Console.ReadLine());

            List<string> guest = new List<string>();

            for (int i = 0; i < numberOfCommands; i++)
            {
                string[] action = Console.ReadLine().Split();
                string name = action[0];

                if (action.Length == 3)
                {
                    if (guest.Contains(name))
                    {
                        Console.WriteLine($"{name} is already in the list!");
                    }
                    else
                    {
                        guest.Add(name);
                    }
                }
                else
                {
                    if (guest.Contains(name))
                    {
                        guest.Remove(name);
                    }
                    else
                    {
                        Console.WriteLine($"{name} is not in the list!");
                    }
                }
            }

            foreach (var item in guest)
            {
                Console.WriteLine(item);
            }
        }
    }
}
