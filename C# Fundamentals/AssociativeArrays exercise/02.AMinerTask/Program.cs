using System;
using System.Collections.Generic;

namespace _02.AMinerTask
{
    class Program
    {
        static void Main(string[] args)
        {
            Dictionary<string, int> miner = new Dictionary<string, int>();

            string resours = Console.ReadLine();

            while (resours != "stop")
            {
                int quantity = int.Parse(Console.ReadLine());

                if (miner.ContainsKey(resours))
                {
                    miner[resours] += quantity;
                }
                else
                {
                    miner.Add(resours, quantity);
                }

                resours = Console.ReadLine();
            }

            foreach (var item in miner)
            {
                Console.WriteLine($"{item.Key} -> {item.Value}");
            }
        }
    }
}
