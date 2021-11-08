using System;

namespace _02.CommonElements
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] first = Console.ReadLine().Split();
            string[] second = Console.ReadLine().Split();

            foreach (var item in second)
            {
                foreach (var element in first)
                {
                    if (element == item)
                    {
                        Console.Write($"{item} ");
                    }
                }
            }

            Console.WriteLine();
        }
    }
}
