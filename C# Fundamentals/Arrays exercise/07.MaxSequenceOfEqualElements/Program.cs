using System;
using System.Linq;

namespace _07.MaxSequenceOfEqualElements
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] number = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToArray();

            int best = 0;
            int bestNum = 0;

            for (int i = 0; i < number.Length; i++)
            {
                int currNum = number[i];
                int sequence = 1;

                for (int j = i + 1; j < number.Length; j++)
                {
                    int rightNum = number[j];

                    if (currNum == rightNum)
                    {
                        sequence++;
                    }
                    else
                    {
                        break;
                    }
                }

                if (sequence > best)
                {
                    best = sequence;
                    bestNum = currNum;
                }
            }

            for (int k = 0; k < best; k++)
            {
                Console.Write(bestNum + " ");
            }

            Console.WriteLine();

        }
    }
}
