using System;
using System.Linq;

namespace _05.TopIntegers
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] integer = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToArray();

            for (int i = 0; i < integer.Length; i++)
            {
                int number = integer[i];
                bool topInt = true;

                for (int j = i + 1; j < integer.Length; j++)
                {
                    int rightNumber = integer[j];

                    if (rightNumber >= number)
                    {
                        topInt = false;
                        break;
                    }
                }

                if (topInt)
                {
                    Console.Write($"{number} ");
                }
            }

            Console.WriteLine();
        }
    }
}
