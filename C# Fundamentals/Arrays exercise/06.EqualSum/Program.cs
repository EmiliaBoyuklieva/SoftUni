using System;
using System.Linq;

namespace _06.EqualSum
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] number = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToArray();

            bool noNum = false;

            for (int i = 0; i < number.Length; i++)
            {
                int rightSum = 0;

                for (int j = 1 + i; j < number.Length; j++)
                {
                    rightSum += number[j];
                }

                int leftSum = 0;

                for (int k = i - 1; k >= 0; k--)
                {
                    leftSum += number[k];
                }

                if (rightSum == leftSum)
                {
                    Console.WriteLine(i);
                    noNum = true;
                    break;
                }
            }

            if (!noNum)
            {
                Console.WriteLine("no");
            }
        }
    }
}
