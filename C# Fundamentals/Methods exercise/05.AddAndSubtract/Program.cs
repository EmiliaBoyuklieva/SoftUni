using System;

namespace _05.AddAndSubtract
{
    class Program
    {
        static void Main(string[] args)
        {
            int first = int.Parse(Console.ReadLine());
            int second = int.Parse(Console.ReadLine());
            int third = int.Parse(Console.ReadLine());

            //Sum(first, second);

            Console.WriteLine(Subtract(third, Sum(first, second)));
        }
        static int Sum(int first, int second)
        {
            return first + second;
        }
        static int Subtract(int third, int sum)
        {
            return sum - third;
        }
    }
    
}
