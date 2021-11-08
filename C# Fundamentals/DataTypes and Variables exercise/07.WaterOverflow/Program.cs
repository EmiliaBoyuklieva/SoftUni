using System;

namespace _07.WaterOverflow
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            int sum = 0;

            for (int i = 0; i < n; i++)
            {
                int quantities = int.Parse(Console.ReadLine());

                int newSum = sum + quantities;

                if (newSum <= 255)
                {
                    sum += quantities;
                }
                else
                {
                    Console.WriteLine("Insufficient capacity!");
                }

            }

            Console.WriteLine(sum);
        }
    }
}
