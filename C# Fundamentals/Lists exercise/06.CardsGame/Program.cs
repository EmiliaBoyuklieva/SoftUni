using System;
using System.Collections.Generic;
using System.Linq;

namespace _06.CardsGame
{
    class Program
    {
        static void Main(string[] args)
        {
            List<int> firstList = Console.ReadLine()
             .Split(" ", StringSplitOptions.RemoveEmptyEntries)
             .Select(int.Parse)
             .ToList();

            List<int> secondList = Console.ReadLine()
              .Split(" ", StringSplitOptions.RemoveEmptyEntries)
              .Select(int.Parse)
              .ToList();

            int firstCounter = 0;
            int secondCounter = 0;

            while (Math.Min(firstList.Count, secondList.Count) > 0)
            {
                if (firstList[0] == secondList[0])
                {
                    firstList.RemoveAt(0);
                    secondList.RemoveAt(0);
                }
                else if (firstList[0] > secondList[0])
                {
                    firstList.Add(firstList[0]);
                    firstList.Add(secondList[0]);
                    secondList.RemoveAt(0);
                    firstList.RemoveAt(0);
                    firstCounter++;
                }
                else if (secondList[0] > firstList[0])
                {
                    secondList.Add(secondList[0]);
                    secondList.Add(firstList[0]);
                    firstList.RemoveAt(0);
                    secondList.RemoveAt(0);
                    secondCounter++;
                }
            }

            if (firstCounter > secondCounter)
            {
                Console.WriteLine($"First player wins! Sum: {firstList.Sum()}");
            }
            else
            {
                Console.WriteLine($"Second player wins! Sum: {secondList.Sum()}");
            }
        }
    }
}
