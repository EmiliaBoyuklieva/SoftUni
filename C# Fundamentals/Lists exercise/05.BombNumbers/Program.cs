using System;
using System.Collections.Generic;
using System.Linq;

namespace _05.BombNumbers
{
    class Program
    {
        static void Main(string[] args)
        {
            List<int> numbers = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToList();

            string[] command = Console.ReadLine().Split();

            int bomb = int.Parse(command[0]);
            int bombPower = int.Parse(command[1]);

            while (true)
            {
                int index = numbers.IndexOf(bomb);

                if (index == -1)
                {
                    break;
                }

                int startIndex = index - bombPower;

                if (startIndex < 0)
                {
                    startIndex = 0;
                }

                int count = 2 * bombPower + 1;

                if (count > numbers.Count - startIndex)
                {
                    count = numbers.Count - startIndex;
                }

                numbers.RemoveRange(startIndex, count);
            }

            int sum = 0;

            for (int k = 0; k < numbers.Count; k++)
            {
                sum += numbers[k];
            }

            Console.WriteLine(sum);
        }
    }
}
