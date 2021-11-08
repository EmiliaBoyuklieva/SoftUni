using System;

namespace _01.Train
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            int[] passenger = new int[n];
            int sum = 0;

            for (int i = 0; i < n; i++)
            {
                int people = int.Parse(Console.ReadLine());

                sum += people;
                passenger[i] = people;
            }

            Console.WriteLine(string.Join(" ", passenger));
            Console.WriteLine(sum);
        }
    }
}
