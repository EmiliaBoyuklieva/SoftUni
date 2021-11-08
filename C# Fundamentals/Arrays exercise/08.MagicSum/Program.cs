using System;
using System.Linq;

namespace _08.MagicSum
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] number = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToArray();

            int magicNum = int.Parse(Console.ReadLine());

            for (int i = 0; i < number.Length; i++)
            {
                int currNum = number[i];

                for (int j = i + 1; j < number.Length; j++)
                {
                    int rightNum = number[j];

                    if (rightNum + currNum == magicNum)
                    {
                        Console.WriteLine($"{currNum} {rightNum}");
                        break;
                    }
                }
            }
        }
    }
}
