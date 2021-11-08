using System;

namespace _02.SumDigits
{
    class Program
    {
        static void Main(string[] args)
        {
            int num = int.Parse(Console.ReadLine());

            int originNum = num;
            int sum = 0;
            int number = 0;

            while (num > 0)
            {
                number = num % 10;
                sum += number;
                num /= 10;
            }

            Console.WriteLine(sum);
        }
    }
}
