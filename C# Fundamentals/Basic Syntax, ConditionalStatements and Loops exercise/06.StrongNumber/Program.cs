using System;

namespace _06.StrongNumber
{
    class Program
    {
        static void Main(string[] args)
        {
            int num = int.Parse(Console.ReadLine());

            int validNum = num;
            int sum = 0;

            while (num > 0)
            {
                int factorial = 1;
                int lastDigit = num % 10;

                for (int j = 1; j <= lastDigit; j++)
                {
                    factorial *= j;
                }

                sum += factorial;
                num /= 10;
            }

            if (sum == validNum)
            {
                Console.WriteLine("yes");
            }
            else
            {
                Console.WriteLine("no");
            }
        }
    }
}
