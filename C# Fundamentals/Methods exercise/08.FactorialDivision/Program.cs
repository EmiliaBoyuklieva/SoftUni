using System;

namespace _08.FactorialDivision
{
    class Program
    {
        static void Main(string[] args)
        {
            double first = int.Parse(Console.ReadLine());
            double second = int.Parse(Console.ReadLine());

            double firstFactorial = GetFactorial(first);
            double secondFactorial = GetFactorial(second);

            double rezult = firstFactorial / secondFactorial;

            Console.WriteLine($"{rezult:f2}");
        }
        static double GetFactorial(double num)
        {
            double factorial = 1;

            for (int i = 1; i <= num; i++)
            {
                factorial *= i;
            }

            return factorial;
        }
    }
}
